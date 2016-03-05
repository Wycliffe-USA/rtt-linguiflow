Puppet::Type.type(:selinux_permissive).provide(:semanage) do

  commands :semanage => 'semanage'

  mk_resource_methods

  def self.instances
    semanage(['permissive', '-n', '-l']).split("\n").map do |permissive|
      new({
        :ensure => :present,
        :name   => permissive,
      })
    end
  end

  def self.prefetch(resources)
    permissives = instances
    resources.keys.each do |name|
      if provider = permissives.find{ |permissive| permissive.name == name }
        resources[name].provider = provider
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    semanage(['permissive', '-a', resource[:name]])
    @property_hash[:ensure] == :present
  end

  def destroy
    semanage(['permissive', '-d', resource[:name]])
    @property_hash.clear
  end
end
