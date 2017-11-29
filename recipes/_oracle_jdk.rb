#
# Cookbook Name:: cloudbees-cjp-ha
# Recipe:: _oracle_jdk
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

package 'software-properties-common' do
  action :install
end

execute 'oracle_jdk_auto_license' do
  command 'echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections'
  action :run
  not_if { File.exist?('/etc/apt/sources.list.d/webupd8team-java-trusty.list') }
end

execute 'install_java_ppa' do
  command 'add-apt-repository -y ppa:webupd8team/java && apt-get update'
  action :run
  not_if { File.exist?('/etc/apt/sources.list.d/webupd8team-java-trusty.list') }
end

package 'oracle-java8-installer' do
  options '-y'
  action :install
end
