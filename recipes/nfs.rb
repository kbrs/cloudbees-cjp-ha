#
# Cookbook Name:: cloudbees-cjp-ha
# Recipe:: nfs
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

# NOTE:
#   This recipe is only intended to let Kitchen get off the ground. BYONFS.

include_recipe 'apparmor'

execute 'remove_apparmor_from_startup' do
  command 'update-rc.d -f apparmor remove'
  action :run
end

directory '/mnt/exports/jenkins' do
  owner 'root'
  group 'root'
  mode '0777'
  recursive true
  action :create
end

directory '/mnt/exports/jenkins-oc' do
  owner 'root'
  group 'root'
  mode '0777'
  recursive true
  action :create
end

template '/etc/exports' do
  source 'exports.erb'
  owner 'root'
  group 'root'
  mode '0777'
end

template '/etc/hosts.allow' do
  source 'hosts.allow.erb'
  owner 'root'
  group 'root'
  mode '0777'
end

template '/etc/hosts.deny' do
  source 'hosts.deny.erb'
  owner 'root'
  group 'root'
  mode '0777'
end

package 'nfs-kernel-server' do
  action :install
end

service 'nfs-kernel-server' do
  supports status: true, restart: true, stop: true, start: true
  action :restart
end

service 'rpc-statd' do
  supports status: true, restart: true, stop: true, start: true
  action :start
end

service 'rpc-statd' do
  supports status: true, restart: true, stop: true, start: true
  action :enable
end
