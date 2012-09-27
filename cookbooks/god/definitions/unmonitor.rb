define :unmonitor, :enable => true do

  include_recipe "god"
  config_path = "/etc/god/conf.d/#{params[:name]}.god"

  file(config_path) do
    action :delete
    notifies :restart, resources(:service => "god")
  end

end
