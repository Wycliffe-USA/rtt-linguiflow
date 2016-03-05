Puppet::Type.newtype(:selinux_permissive) do
  @doc = "Manage SELinux processes type enforcement mode."

  ensurable

  newparam(:name) do
    desc "The default namevar."
  end
end
