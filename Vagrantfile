VAGRANT_API_VERSION = 2

Vagrant.configure(VAGRANT_API_VERSION) do |config|
  config.vm.define 'default' do |item|
    item.vm.box = 'ubuntu/trusty64'

    item.vm.network 'private_network', ip: '192.168.139.4' # NOTE: for nfs
    item.vm.synced_folder ".", "/vagrant", type: "nfs"

    item.ssh.forward_agent = true

    item.vm.provision 'ansible' do |ansible|
      ansible.playbook = 'cm/vagrant.yml'
      ansible.verbose = 'vv'
      ansible.inventory_path = 'cm/local'
      ansible.limit = 'all'
    end

    item.vm.provider 'virtualbox' do |v, _override|
      v.memory = 2048
    end
  end
end
