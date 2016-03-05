Puppet::Type.type(:selinux_port).provide(:semanage) do

  commands :semanage => 'semanage', :restorecon => 'restorecon'

  mk_resource_methods

  def self.instances
    resources = []
    semanage(['port', '-n', '-l']).split("\n").map do |port|
      seltype, proto, ports = port.split(' ', 3)
      ports.gsub(/\s+/, "").split(',').map do |p|
        resources << new({
          :ensure  => :present,
          :name    => "#{seltype}/#{proto}/#{p}",
          :seltype => seltype,
          :proto   => proto,
          :port    => p,
        })
      end
    end
    resources
  end

  def self.prefetch(resources)
    ports = instances
    resources.keys.each do |name|
      if provider = ports.find{ |port|
        port.seltype.to_s == resources[name][:seltype].to_s \
        && port.proto.to_s == resources[name][:proto].to_s \
        && port.port.to_s == resources[name][:port].to_s
      }
        resources[name].provider = provider
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    semanage(['port', '-a', resource[:seltype], '-p', resource[:proto].to_s, resource[:port]])
    @property_hash[:ensure] == :present
  end

  def destroy
    semanage(['port', '-d', resource[:seltype], '-p', resource[:proto].to_s, resource[:port]])
    @property_hash.clear
  end

  def port=(value)
    semanage(['port', '-m', resource[:seltype], '-p', resource[:proto].to_s, value])
    @property_hash[:port] = value
  end
end
