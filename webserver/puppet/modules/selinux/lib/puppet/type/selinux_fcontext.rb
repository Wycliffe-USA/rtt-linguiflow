Puppet::Type.newtype(:selinux_fcontext) do
  @doc = "Manage SELinux file context mapping definitions."

  ensurable

  newparam(:name) do
    desc "The default namevar."
  end

  newproperty(:seluser) do
    desc "The SELinux user to apply."
  end

  newproperty(:selrole) do
    desc "The SELinux role to apply."
  end

  newproperty(:seltype) do
    desc "The SELinux type to apply."
  end

  newproperty(:selrange) do
    desc "The SELinux range to apply."
  end
end
