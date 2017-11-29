#
# Cookbook Name:: cloudbees-cjp-ha
# Recipe:: _add_hosts
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

# Some shops utilize a NAT gateway in front of their HAProxy. For those who do,
# you can use this to keep CJP cluster traffic local. Setting as default since
# there's no harm in it. -elk

LB_INT_IP = node['cloudbees-cjp-ha']['haproxy']['keepalived']['virt_ip']

hostsfile_entry node['cloudbees-cjp-ha']['haproxy']['keepalived']['virt_ip'] do
  hostname  node['cloudbees-cjp-ha']['haproxy']['keepalived']['virt_hostname']
  aliases   [node['cloudbees-cjp-ha']['haproxy']['keepalived']['virt_shostname'], '']
  comment   'Append by cloudbees-cjp-ha::_add_hosts'
  action    :append
  only_if { File.readlines('/etc/hosts').grep(/#{LB_INT_IP}/).empty? }
end
