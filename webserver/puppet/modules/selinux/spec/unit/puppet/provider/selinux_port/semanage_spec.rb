require 'spec_helper'

describe Puppet::Type.type(:selinux_port).provider(:semanage) do

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

      context 'without ports' do
        it 'should return no resources' do
          described_class.expects(:semanage).with(['port', '-n', '-l']).returns ''
          expect(described_class.instances.size).to eq(0)
        end
      end

      context 'with a port' do
        before :each do
          described_class.expects(:semanage).with(['port', '-n', '-l']).returns 'http_port_t                 tcp      80, 443'
        end
        it do
          expect(described_class.instances.size).to eq(2)
        end
        it do
          expect(described_class.instances[0].instance_variable_get("@property_hash")).to eq( {
            :ensure  => :present,
            :name    => 'http_port_t/tcp/80',
            :seltype => 'http_port_t',
            :proto   => 'tcp',
            :port    => '80',
          } )
        end
        it do
          expect(described_class.instances[1].instance_variable_get("@property_hash")).to eq( {
            :ensure  => :present,
            :name    => 'http_port_t/tcp/443',
            :seltype => 'http_port_t',
            :proto   => 'tcp',
            :port    => '443',
          } )
        end
      end

      context 'when manipulating objects' do
        let(:resource) do
          Puppet::Type.type(:selinux_port).new({:name => 'http_port_t/tcp/81', :provider => 'semanage'})
        end

        let(:provider) do
          resource.provider
        end

        context 'when allowing Apache to listen on tcp port 81' do
          it 'should call `semanage port -a -t http_port_t -p tcp 81`' do
            provider.expects(:semanage).with(['port', '-a', 'http_port_t', '-p', 'tcp', '81'])
            provider.create
          end
        end

        context 'when disallowing Apache to listen on tcp port 81' do
          it 'should call `semanage port -d http_port_t -p tcp 81`' do
            provider.expects(:semanage).with(['port', '-d', 'http_port_t', '-p', 'tcp', '81'])
            provider.destroy
          end
        end
      end

      context 'when not using composite namevar' do
        let(:resource) do
          Puppet::Type.type(:selinux_port).new({:name => 'myport', :seltype => 'http_port_t', :proto => 'tcp', :port => '81', :provider => 'semanage'})
        end

        let(:provider) do
          resource.provider
        end

        context 'when allowing Apache to listen on tcp port 81' do
          it 'should call `semanage port -a -t http_port_t -p tcp 81`' do
            provider.expects(:semanage).with(['port', '-a', 'http_port_t', '-p', 'tcp', '81'])
            provider.create
          end
        end

        context 'when disallowing Apache to listen on tcp port 81' do
          it 'should call `semanage port -d http_port_t -p tcp 81`' do
            provider.expects(:semanage).with(['port', '-d', 'http_port_t', '-p', 'tcp', '81'])
            provider.destroy
          end
        end
      end
    end
  end
end
