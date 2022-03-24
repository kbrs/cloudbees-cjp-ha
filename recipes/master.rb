#
# Cookbook Name:: cloudbees-cjp-ha
# Recipe:: master
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

include_recipe 'apparmor'

execute 'remove_apparmor_from_startup' do
  command 'update-rc.d -f apparmor remove'
  action :run
end

include_recipe 'cloudbees-cjp-ha::_mail_relay'
include_recipe 'cloudbees-cjp-ha::_mst_nfs_mounts'
include_recipe 'cloudbees-cjp-ha::_mst_ip_multicast'
include_recipe 'cloudbees-cjp-ha::_openjdk'
include_recipe 'cloudbees-cjp-ha::_increase_file_limits'
include_recipe 'cloudbees-cjp-ha::_add_hosts'

service 'jenkins' do
  supports status: true, restart: true, stop: true, start: true
  action :nothing
end

# install deps
%w(
  daemon
  psmisc
  curl
  git
  libpq-dev
  libxml2-dev
  openssl
).each do |pkg|
  package pkg
end

# Install Jenkins
apt_repository 'jenkins' do
  uri 'https://downloads.cloudbees.com/cje/rolling/debian/'
  distribution 'binary/'
  key 'https://downloads.cloudbees.com/cje/rolling/debian/cloudbees.com.key'
  not_if { File.exist?('/etc/apt/sources.list.d/jenkins.list') }
end

package 'jenkins' do
 # version node['cloudbees-cjp-ha']['master']['package']['version']
  action :install
  notifies :nothing, 'service[jenkins]', :immediately
end

# Setup directory for jenkins.war to run in - NOT NFS MOUNTS.
directory '/opt/jenkins/war' do
  mode '0777'
  recursive true
  action :create
end

# configure jenkins
template '/etc/default/jenkins' do
  source   'master-config-debian.erb'
  mode     '0644'
  notifies :restart, 'service[jenkins]', :delayed
end

# Configure JGroups template
# template '/var/lib/jenkins/jgroups.xml' do
#   source 'tcp-jgroups.xml.erb' # specify udp or tcp. defaults to tcp in latest rev.
#   owner 'jenkins'
#   group 'jenkins'
#   mode '0644'
#   notifies :restart, 'service[jenkins]', :delayed
# end
