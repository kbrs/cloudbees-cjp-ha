#
# Cookbook Name:: cloudbees-cjp-ha
# Recipe:: opcenter
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
include_recipe 'cloudbees-cjp-ha::_opc_nfs_mounts'
include_recipe 'cloudbees-cjp-ha::_opc_ip_multicast'
include_recipe 'cloudbees-cjp-ha::_oracle_jdk'
include_recipe 'cloudbees-cjp-ha::_increase_file_limits'
include_recipe 'cloudbees-cjp-ha::_add_hosts'

service 'jenkins-oc' do
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

apt_repository 'jenkins' do
  uri 'https://downloads.cloudbees.com/cjoc/rolling/debian/'
  distribution 'binary/'
  key 'https://downloads.cloudbees.com/cjoc/rolling/debian/cloudbees.com.key'
  not_if { File.exist?('/etc/apt/sources.list.d/jenkins.list') }
end

package 'jenkins-oc' do
  version node['cloudbees-cjp-ha']['opcenter']['package']['version']
  action :install
  notifies :nothing, 'service[jenkins-oc]', :immediately
end

# Setup directory for jenkins-oc.war to run in
directory '/opt/jenkins/war' do
  mode '0777'
  recursive true
  action :create
end

# configure jenkins-oc
template '/etc/default/jenkins-oc' do
  source   'opcenter-config-debian.erb'
  mode     '0644'
  notifies :restart, 'service[jenkins-oc]', :delayed
end

# Configure JGroups template
template '/var/lib/jenkins-oc/jgroups.xml' do
  source 'tcp-jgroups.xml.erb'
  owner 'jenkins-oc'
  group 'jenkins-oc'
  mode '0644'
  notifies :restart, 'service[jenkins-oc]', :delayed
end
