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
