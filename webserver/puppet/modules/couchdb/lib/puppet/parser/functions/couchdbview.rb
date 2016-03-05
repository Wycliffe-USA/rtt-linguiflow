module Puppet::Parser::Functions
  newfunction(:couchdbview, :type => :rvalue, :doc => <<-EOS
    Querying CouchDB documents with a temporary view. Example:

      $result = couchdbview(
        'URI/{dbname}/_temp_view', 
        '{"map": "function(doc){emit(null, doc);}"}'
      )

    The variable $result will contain a hash with the following form:

      {
        "doc1_id":{"key1":"value1","key2":"value2",... },
        "doc2_id":{"key1":"value1","key2":"value2",... },
        ...
      }
    EOS
    ) do |args|
    
    require 'json'
    require 'open-uri'
    require 'net/http'

    raise Puppet::ParseError, ("couchdbview(): wrong number of arguments (#{args.length}; must be 2 or 3)") unless args.length.between?(2, 3)

    url = args[0]
    view = args[1]
    default = args[2] if args.length >= 3

    if lookupvar('vagrantbox') != :undefined
      Puppet.send(:warning, "Bypassing couchdbview() because 'vagrantbox' fact is defined!")
      return default ? default : :undef
    end

    begin
      uri = URI.parse(url)
      headers = {'Content-Type'    => 'application/json',
                 'Accept-Encoding' => 'gzip,deflate',
                 'Accept'          => 'application/json'}
      http = Net::HTTP.new(uri.host,uri.port)
      response = http.post(uri.path, JSON.parse(view).to_json, headers)
    rescue OpenURI::HTTPError, Timeout::Error, Errno::EINVAL, 
           Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, 
           Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
      raise Puppet::ParseError, "couchdbview(): '#{e.message}'"
    end

    if response.code != '200'
      default or raise Puppet::ParseError, "couchdbview(): HTTP Error '#{response.code}'"
    end

    result = Hash.new

    begin
      JSON.parse(response.body)['rows'].each {|n|
        values = n['value']
        values.delete('_id')
        values.delete('_rev')
        result[n['id']] = n['value']
      }
    rescue JSON::ParserError => e
      raise Puppet::ParseError, "couchdbview(): failed to parse JSON '#{e.message}'"
    end
 
    if result.nil?
      default or raise Puppet::ParseError, "couchdbview(): no documents found!"
    else
      result
    end

  end
end

