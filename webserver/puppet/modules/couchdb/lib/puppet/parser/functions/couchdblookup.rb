#
# NB: this function has tests. If you change something, please also update
# spec/unit/puppet/parser/functions/couchdblookup_spec.rb
#
# You can run the tests with "rake spec"
#

module Puppet::Parser::Functions
  newfunction(:couchdblookup, :type => :rvalue, :doc => <<-EOS
*Retrieve values from couchdb*

Takes a CouchDB URL and a key as argument, and returns the value. If the key
isn't found, it will return a parse error, or the value specified in the
optional 3rd argument.

*Example:*

    $couchdburl = 'http://localhost:5984/users'
    couchdblookup("${couchdburl}/joe", 'ssh_pubkey')
    couchdblookup("${couchdburl}/bob", 'ssh_pubkey', 'invalid-key')

If the "vagrantbox" fact is set, it will always return "undef" (assuming the
couchdb server is unreachable from inside a vagrant box).

  EOS
  ) do |args|
    require 'json'
    require 'open-uri'

    raise Puppet::ParseError, ("couchdblookup(): wrong number of arguments (#{args.length}; must be 2 or 3)") unless args.length.between?(2, 3)

    url = args[0]
    key = args[1]
    default = args[2] if args.length >= 3

    begin
      if exist?('vagrantbox') && lookupvar('vagrantbox') == true
        Puppet.send(:warning, "Bypassing couchdb lookup because 'vagrantbox' fact is defined. couchdblookup() will not return what you expect !")
        return default ? default : :undef
      end
    rescue Puppet::ParseError
      # do nothing
    end

    begin
      json = JSON.parse(open(URI.parse(url)).read)
    rescue OpenURI::HTTPError => error
      raise Puppet::ParseError, "couchdblookup(): fetching URL #{url} failed with status '#{error.message}'"
    rescue Timeout::Error => error
      raise Puppet::ParseError, "couchdblookup(): connection to couchdb server timed out: '#{error.message}'"
    rescue Errno::ECONNREFUSED => error
      raise Puppet::ParseError, "couchdblookup(): connection to couchdb server failed: '#{error.message}'"
    rescue JSON::ParserError => error
      raise Puppet::ParseError, "couchdblookup(): failed to parse JSON received from couchdb: '#{error.message}'"
    rescue StandardError => error
      raise Puppet::ParseError, "couchdblookup(): something unexpected happened: '#{error.inspect}'"
    end

    result = nil

    if json.has_key?("rows")

      if json['rows'].length > 1
        arr = json['rows'].collect do |x|
          x[key] if x.is_a?(Hash) and x.has_key?(key)
        end
        arr.compact!
        result = arr unless arr.empty?

      elsif json['rows'].length == 1
        hash = json['rows'].pop
        result = hash[key] if hash.is_a?(Hash)
      end

    elsif json.has_key?(key)
      result = json[key]
    end

    if result.nil?
      default or raise Puppet::ParseError, "couchdblookup(): key '#{key}' '#{result}' not found in JSON object at '#{url}' !"
    else
      result
    end

  end
end

