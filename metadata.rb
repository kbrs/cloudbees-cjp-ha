name             'cloudbees-cjp-ha'
maintainer       'Erin L. Kolp'
maintainer_email 'ekolp@kickbackpoints.com'
source_url	     'https://github.com/kbrs/cloudbees-cjp-ha/issues'
issues_url	     'https://github.com/kbrs/cloudbees-cjp-ha'
license          'GPL-2.0'
description      'Installs/Configures Cloudbees CJP with High-Availability'
long_description 'Installs/Configures Cloudbees CJP with High-Availability'
chef_version '>= 15.17.4' if respond_to?(:chef_version)
version          '22.4.0'
%w[
  debian
  ubuntu
].each do |os|
  supports os
end

depends 'postfix', '~>3.7.0'
depends 'apparmor', '~>2.0.1'
depends 'apt', '~>4.0.2'
depends 'hostsfile', '~> 2.4.5'
