#
# Cookbook Name:: cloudbees-cjp-ha
# Recipe:: _ip_multicast
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

service 'procps' do
  supports status: true, restart: true, stop: true, start: true
  action :nothing
end

route 'ip4_multicast' do
  device node['cloudbees-cjp-ha']['master']['ip4_multicast']['interface']
  netmask '240.0.0.0'
  target '224.0.0.0'
  action :add
end

template '/etc/network/if-up.d/post_up_multicast_route' do
  source 'post_up_multicast_route.erb'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

execute 'enable_ip4_forwarding' do
  cwd '/root/'
  command "echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf"
  not_if { !File.readlines('/etc/sysctl.conf').grep(/net.ipv4.ip_forward=1/).empty? }
  notifies :restart, 'service[procps]', :immediately
end
