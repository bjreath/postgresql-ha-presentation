# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "precise64"

  config.vm.define :master do |master_config|
    master_config.vm.network :hostonly, "192.168.1.11"

    master_config.vm.provision :chef_solo do |master_chef|
      master_chef.cookbooks_path = "./cookbooks"
      master_chef.data_bags_path = "./data_bags"

      master_chef.add_recipe 'ruby'
      master_chef.add_recipe 'god'
      master_chef.add_recipe 'postgresql'
    end
  end

  config.vm.define :standby do |standby_config|
    standby_config.vm.network :hostonly, "192.168.1.12"

    standby_config.vm.provision :chef_solo do |standby_chef|
      standby_chef.cookbooks_path = "./cookbooks"
      standby_chef.data_bags_path = "./data_bags"

      standby_chef.add_recipe 'ruby'
      standby_chef.add_recipe 'god'
    end
  end

  config.vm.define :web do |web_config|
    web_config.vm.network :hostonly, "192.168.1.10"

    web_config.vm.provision :chef_solo do |web_chef|
      web_chef.cookbooks_path = "./cookbooks"
      web_chef.data_bags_path = "./data_bags"

      web_chef.add_recipe 'ruby'
      web_chef.add_recipe 'god'
      web_chef.add_recipe 'nginx'
      web_chef.add_recipe 'todos'
    end

    web_config.vm.forward_port 80, 5678
  end
end
