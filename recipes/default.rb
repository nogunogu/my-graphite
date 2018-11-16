#
# Cookbook:: my-graphite
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

docker_service 'default' do
  action [:create, :start]
end

docker_image 'graphiteapp/graphite-statsd'

docker_container 'graphite' do
  repo 'graphiteapp/graphite-statsd'
  container_name 'graphite'
  restart_policy 'always'
  port ['80:80', '2003-2004:2003-2004','2023-2024:2023-2024', '8125:8125/udp', '8126:8126']
end


include_recipe 'collectd::default'

collectd_plugin_file 'write' do
  plugin_instance_name 'graphite'
  cookbook 'my-graphite'
  source 'write_graphite.conf.erb'
  variables()
  notifies :restart, "collectd_service[#{node['collectd']['service_name']}]"
  not_if { node['graphite']['hostname'].empty? }
end

collectd_plugin 'df' do
  options(
    :ignore_selected => true
  )
  notifies :restart, "collectd_service[#{node['collectd']['service_name']}]", :delayed
end
