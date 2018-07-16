Vagrant.configure('2') do |config|
  config.vm.box = 'bento/ubuntu-16.04'

  if Vagrant.has_plugin?('vagrant-cachier')
    config.cache.scope = :box
    config.cache.synced_folder_opts = {
      owner: '_apt',
      group: '_apt',
      mount_options: ['dmode=777', 'fmode=666']
    }
  end

  config.vm.provider 'virtualbox' do |vb|
    vb.memory = ENV['VM_MEMORY'] || 1024
    vb.cpus = 2
    vb.customize ['modifyvm', :id, '--nictype1', 'virtio']
    vb.customize [
      'modifyvm', :id,
      '--hwvirtex', 'on',
      '--nestedpaging', 'on',
      '--largepages', 'on',
      '--ioapic', 'on',
      '--pae', 'on',
      '--paravirtprovider', 'kvm',
    ]

    # Don't boot with headless mode
    vb.gui = true if ENV['VM_GUI']
  end

  config.vm.provision 'ansible' do |ansible|
    ansible.playbook = 'provision/playbook.yml'
    #ansible.inventory_path = 'provision/hosts'
    ansible.limit = 'all'
    ansible.verbose = ENV['ANSIBLE_VERBOSE'] if ENV['ANSIBLE_VERBOSE']
    ansible.tags = ENV['ANSIBLE_TAGS'] if ENV['ANSIBLE_TAGS']

    ansible.galaxy_role_file = 'provision/requirements.yml'
    # without --force
    ansible.galaxy_command = 'ansible-galaxy install --role-file=%{role_file} --roles-path=%{roles_path}'

    vars = {
      stage: 'vagrant',
      nadoka: [],
    }
    if ENV.key?('NADOKA_SERVICE_NAME')
      vars[:nadoka] << {
        service_name: ENV['NADOKA_SERVICE_NAME'],
        irc_host: ENV['NADOKA_IRC_HOST'],
        irc_port: ENV['NADOKA_IRC_PORT'],
        irc_pass: ENV['NADOKA_IRC_PASS'],
        irc_ssl_params: '{}',
        irc_nick: 'User',
        channel_info: ENV['NADOKA_CHANNEL_INFO'],
      }
    end
    ansible.extra_vars = vars
  end
end
