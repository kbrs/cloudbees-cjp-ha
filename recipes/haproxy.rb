#
# Cookbook Name:: cloudbees-cjp-ha
# Recipe:: haproxy
#
# Copyright (C) 2017 KickBack Rewards Systems <noc@kickbackpoints.com>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

include_recipe 'cloudbees-cjp-ha::_add_hosts'
include_recipe 'cloudbees-cjp-ha::_mail_relay'

service 'procps' do
  supports status: true, restart: true, stop: true, start: true
  action :nothing
end

service 'haproxy' do
  supports status: true, restart: true, stop: true, start: true, reload: true
  action :nothing
end

service 'keepalived' do
  supports status: true, restart: true, stop: true, start: true
  action :nothing
end

package 'software-properties-common' do
  action :install
end

%w(
  openssl
  apt-transport-https
  ca-certificates
).each do |pkg|
  package pkg
end

# remove.already included in 20.04. -cbk
# execute 'add_haproxy_repo' do
#   command 'add-apt-repository -y ppa:vbernat/haproxy-1.6 && apt-get update'
#   action :run
#   not_if { File.exist?('/etc/apt/sources.list.d/vbernat-haproxy-1_6-trusty.list') }
# end

package 'haproxy' do
  options '-y'
  action :install
end

package 'keepalived' do
  options '-y'
  action :install
end

# allow bind to virt ip
PARAM = 'net.ipv4.ip_nonlocal_bind=1'.freeze

execute 'enable_ip4_forwarding' do
  cwd '/root/'
  command "echo '#{PARAM}' >> /etc/sysctl.conf"
  notifies :restart, 'service[procps]', :immediately
  only_if { File.readlines('/etc/sysctl.conf').grep(/#{PARAM}/).empty? }
end

# enable haproxy
template '/etc/default/haproxy' do
  source 'haproxy_default.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[haproxy]', :immediately
end

# configure haproxy
template '/etc/haproxy/haproxy.cfg' do
  source 'haproxy.cfg.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :reload, 'service[haproxy]', :immediately
end

# setup keepalived
template '/etc/keepalived/keepalived.conf' do
  source 'keepalived.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[keepalived]', :immediately
end
