#
# Cookbook Name:: cloudbees-cjp-ha
# Recipe:: _increase_file_limits
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

# increase max open file/proc for jenkins and jenkins-oc
template '/etc/security/limits.conf' do
  source 'limits.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

# enable session required pam_limits.so
template '/etc/pam.d/su' do
  source 'su.erb'
  owner 'root'
  group 'root'
  mode '0644'
end
