require 'spec_helper'

describe Puppet::Type.type(:selinux_permissive).provider(:semanage) do

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

      context 'without permissives' do
        it 'should return no resources' do
          described_class.expects(:semanage).with(['permissive', '-n', '-l']).returns ''
          expect(described_class.instances.size).to eq(0)
        end
      end

      context 'with a permissive' do
        before :each do
          described_class.expects(:semanage).with(['permissive', '-n', '-l']).returns 'nova_api_t
'
        end
        it 'should return one resource' do
          expect(described_class.instances.size).to eq(1)
        end
        it 'should return nova_api_t as first element' do
          expect(described_class.instances[0].instance_variable_get("@property_hash")).to eq( {
            :ensure   => :present,
            :name     => 'nova_api_t',
          } )
        end
      end

      context 'with two permissives' do
        before :each do
          described_class.expects(:semanage).with(['permissive', '-n', '-l']).returns 'nova_api_t
sblim_reposd_t
'
        end
        it 'should return two resource' do
          expect(described_class.instances.size).to eq(2)
        end
        it 'should return sblim_reposd_t as second element' do
          expect(described_class.instances[1].instance_variable_get("@property_hash")).to eq( {
            :ensure   => :present,
            :name     => 'sblim_reposd_t',
          } )
        end
      end

      context 'when manipulating objects' do
        let(:resource) do
          Puppet::Type.type(:selinux_permissive).new({:name => 'httpd_t', :provider => 'semanage'})
        end

        let(:provider) do
          resource.provider
        end

        context 'when adding httpd_t permissive' do
          it 'should call semanage permissive -a httpd_t' do
            provider.expects(:semanage).with(['permissive', '-a', 'httpd_t'])
            provider.create
          end
        end

        context 'when removing httpd_d permissive' do
          it 'should call semanage permissive -d httpd_t' do
            provider.expects(:semanage).with(['permissive', '-d', 'httpd_t'])
            provider.destroy
          end
        end
      end
    end
  end
end
