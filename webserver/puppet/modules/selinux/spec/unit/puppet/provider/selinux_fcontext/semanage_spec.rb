require 'spec_helper'

describe Puppet::Type.type(:selinux_fcontext).provider(:semanage) do

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      before :each do
        Facter.clear
        facts.each do |k, v|
          Facter.stubs(:fact).with(k).returns Facter.add(k) { setcode { v } }
        end
      end

      describe 'instances' do
        it 'should have an instance method' do
          expect(described_class).to respond_to :instances
        end
      end

      describe 'prefetch' do
        it 'should have a prefetch method' do
          expect(described_class).to respond_to :prefetch
        end
      end

      context 'without file contexts' do
        it 'should return no resources' do
          described_class.expects(:semanage).with(['fcontext', '-n', '-l', '-C']).returns ''
          expect(described_class.instances.size).to eq(0)
        end
      end

      context 'with a file context' do
        before :each do
          described_class.expects(:semanage).with(['fcontext', '-n', '-l', '-C']).returns \
            '/                                                  directory          system_u:object_r:root_t:s0 '
        end
        it 'should return one resource' do
          expect(described_class.instances.size).to eq(1)
        end
        it 'should return / file' do
          expect(described_class.instances[0].instance_variable_get("@property_hash")).to eq( {
            :ensure   => :present,
            :name     => '/',
            :seluser  => 'system_u',
            :selrole  => 'object_r',
            :seltype  => 'root_t',
            :selrange => 's0',
          } )
        end
      end

      context 'with two file contexts' do
        before :each do
          described_class.expects(:semanage).with(['fcontext', '-n', '-l', '-C']).returns \
            '/                                                  directory          system_u:object_r:root_t:s0 
/.*                                                all files          system_u:object_r:default_t:s0 '
        end
        it 'should return two resources' do
          expect(described_class.instances.size).to eq(2)
        end
        it 'should return /.*' do
          expect(described_class.instances[1].instance_variable_get("@property_hash")).to eq( {
            :ensure   => :present,
            :name     => '/.*',
            :seluser  => 'system_u',
            :selrole  => 'object_r',
            :seltype  => 'default_t',
            :selrange => 's0',
          } )
        end
      end

      let(:resource) do
        Puppet::Type.type(:selinux_fcontext).new(
          {
            :name     => '/web(/.*)?',
            :provider => 'semanage',
            :seltype  => 'httpd_sys_content_t',
          }
        )
      end

      let(:provider) do
        resource.provider
      end

      context 'when creating an fcontext' do
        it 'should create a new entry' do
          provider.expects(:semanage).with(['fcontext', '-a', '--type', 'httpd_sys_content_t', '/web(/.*)?'])
          provider.expects(:restorecon).with(['-R', '/web'])
          provider.create
        end

        it 'should use --seuser when seluser is set' do
          resource[:seluser] = 'user_u'
          provider.expects(:semanage).with(includes('--seuser'))
          provider.expects(:restorecon).with(['-R', '/web'])
          provider.create
        end
      end

      context 'when destroying an fcontext' do
        it 'should destroy an entry' do
          provider.expects(:semanage).with(['fcontext', '-d', '/web(/.*)?'])
          provider.expects(:restorecon).with(['-R', '/web'])
          provider.destroy
        end
      end

      context 'when modifying an fcontext' do
        it 'should update the seluser' do
          provider.expects(:semanage).with(['fcontext', '-m', '--seuser', 'user_u', '/web(/.*)?'])
          provider.expects(:restorecon).with(['-R', '/web'])
          provider.seluser = 'user_u'
          provider.flush
        end

        it 'should update the selrole' do
          provider.expects(:semanage).with(['fcontext', '-m', '--role', 'object_r', '/web(/.*)?'])
          provider.expects(:restorecon).with(['-R', '/web'])
          provider.selrole = 'object_r'
          provider.flush
        end

        it 'should update the seltype' do
          provider.expects(:semanage).with(['fcontext', '-m', '--type', 'default_t', '/web(/.*)?'])
          provider.expects(:restorecon).with(['-R', '/web'])
          provider.seltype = 'default_t'
          provider.flush
        end

        it 'should update the selrange' do
          provider.expects(:semanage).with(['fcontext', '-m', '--range', 's0-s0:c0.c1023', '/web(/.*)?'])
          provider.expects(:restorecon).with(['-R', '/web'])
          provider.selrange = 's0-s0:c0.c1023'
          provider.flush
        end
      end
    end
  end
end
