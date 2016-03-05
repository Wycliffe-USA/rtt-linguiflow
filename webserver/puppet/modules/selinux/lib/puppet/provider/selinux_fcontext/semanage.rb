Puppet::Type.type(:selinux_fcontext).provide(:semanage) do

  commands :semanage => 'semanage', :restorecon => 'restorecon'

  mk_resource_methods

  def self.instances
    semanage(['fcontext', '-n', '-l', '-C']).split("\n").map do |fcontext|
      name, context = fcontext.split.values_at(0, -1)
      seluser, selrole, seltype, selrange = context.split(':')
      new({
        :ensure   => :present,
        :name     => name,
        :seluser  => seluser,
        :selrole  => selrole,
        :seltype  => seltype,
        :selrange => selrange,
      })
    end
  end

  def self.prefetch(resources)
    fcontexts = instances
    resources.keys.each do |name|
      if provider = fcontexts.find{ |fcontext| fcontext.name == name }
        resources[name].provider = provider
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    args = ['fcontext', '-a']
    args << ['--seuser', resource[:seluser]] if resource[:seluser]
    args << ['--role', resource[:selrole]] if resource[:selrole]
    args << ['--type', resource[:seltype]] if resource[:seltype]
    args << ['--range', resource[:selrange]] if resource[:selrange]
    args << resource[:name]
    semanage(args.flatten)
    restorecon(['-R', resource[:name].split('(')[0]])
    @property_hash[:ensure] == :present
  end

  def destroy
    semanage(['fcontext', '-d', resource[:name]])
    restorecon(['-R', resource[:name].split('(')[0]])
    @property_hash.clear
  end

  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  def seluser=(value)
    @property_flush[:seluser] = value
  end

  def selrole=(value)
    @property_flush[:selrole] = value
  end

  def seltype=(value)
    @property_flush[:seltype] = value
  end

  def selrange=(value)
    @property_flush[:selrange] = value
  end

  def flush
    if not @property_flush.empty?
      args = ['fcontext', '-m']
      args << ['--seuser', @property_flush[:seluser]] if @property_flush[:seluser]
      args << ['--role', @property_flush[:selrole]] if @property_flush[:selrole]
      args << ['--type', @property_flush[:seltype]] if @property_flush[:seltype]
      args << ['--range', @property_flush[:selrange]] if @property_flush[:selrange]
      args << resource[:name]
      semanage(args.flatten)
      restorecon(['-R', resource[:name].split('(')[0]])
      @property_hash = resource.to_hash
    end
  end
end
