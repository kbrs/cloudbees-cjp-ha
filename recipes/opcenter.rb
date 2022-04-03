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

# return

include_recipe 'cloudbees-cjp-ha::_opc_ip_multicast'
include_recipe 'cloudbees-cjp-ha::_openjdk'
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

# root@opcenter00:/var/log/jenkins-oc# apt-cache madison jenkins-oc
# jenkins-oc |  2.332.1.5 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.332.1.4 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.319.3.4 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.319.3.3 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.319.2.9 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.319.2.7 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.319.2.5 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.319.1.5 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.303.3.3 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.303.2.6 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.303.2.5 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.303.2.3 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.303.1.6 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.303.1.5 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.289.3.2 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.289.2.3 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.289.2.2 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.289.1.2 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.277.4.4 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.277.4.3 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.277.4.2 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.277.3.1 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.277.2.3 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.277.1.2 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.263.4.2 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.263.4.1 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.263.2.3 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.263.2.2 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.263.1.2 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.249.3.3 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.249.3.2 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.249.3.1 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.249.2.4 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.249.2.3 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.249.1.2 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.235.5.1 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.235.4.1 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.235.2.3 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.235.1.2 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.222.4.3 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.222.2.1 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.222.1.1 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.204.3.7 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.204.3.4 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.204.2.2 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.204.1.3 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.190.3.2 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.190.2.2 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.176.4.3 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.176.3.3 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.176.3.2 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.176.2.3 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.176.1.4 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.164.3.2 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.164.2.1 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.164.1.2 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.150.3.2 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.150.2.3 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.138.4.3 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.138.3.1 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.138.2.2 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.138.1.2 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.121.3.1 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.121.2.1 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.121.1.2 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.107.3.4 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.107.3.2 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.107.2.1 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  2.107.1.2 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |   2.89.4.2 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |   2.89.3.4 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |   2.89.1.7 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |   2.89.1.6 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |   2.73.3.1 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |   2.73.2.1 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |   2.73.1.2 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |   2.60.3.1 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |   2.60.2.2 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |   2.60.1.1 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages
# jenkins-oc |  1.999.1.1 | https://downloads.cloudbees.com/cjoc/rolling/debian binary/ Packages

