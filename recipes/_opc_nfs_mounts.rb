#
# Cookbook Name:: cloudbees-cjp-ha
# Recipe:: _opc_nfs_mounts
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

directory '/var/lib/jenkins-oc' do
  mode '0777'
  recursive true
  action :create
end

package 'nfs-common' do
  action :install
end

mount '/var/lib/jenkins-oc' do
  device node['cloudbees-cjp-ha']['opcenter']['nfs_mount']['device']
  fstype node['cloudbees-cjp-ha']['opcenter']['nfs_mount']['fstype']
  options node['cloudbees-cjp-ha']['opcenter']['nfs_mount']['options']
  action %i(mount enable)
end
