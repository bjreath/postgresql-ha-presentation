# This can be called from other recipes like so:
#
#   monitor("service") do
#     source "service.god.erb"
#   end
#
# The argument passed into the monitor call will be available as params[:name],
# and the source argument will be available as params[:source].
#

define :monitor, :enable => true do

  include_recipe "god"
  config_path = "/etc/god/conf.d/#{params[:name]}.god"

  template(config_path) do
    source params[:source] || "default.god.erb"
    cookbook params[:cookbook]
    variables params
    backup false
    notifies :restart, "service[god]"
  end

end
