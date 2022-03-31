##############################################################
# Keepalived Params                                          #
##############################################################
# keepalived priority is set in the node attributes.
default['cloudbees-cjp-ha']['haproxy']['keepalived']['priority'] = ''

# virtual ip address and host of the proxy
default['cloudbees-cjp-ha']['haproxy']['keepalived']['virt_ip'] = '192.168.254.10'
default['cloudbees-cjp-ha']['haproxy']['keepalived']['virt_hostname'] = 'jenkins.yourorg.io'
default['cloudbees-cjp-ha']['haproxy']['keepalived']['virt_shostname'] = 'jenkins'
default['cloudbees-cjp-ha']['haproxy']['keepalived']['virt_int'] = 'enp0s8'
default['cloudbees-cjp-ha']['haproxy']['keepalived']['interval'] = '2'

# notification settings for vip movement. set to root@localhost if you don't want email.
default['cloudbees-cjp-ha']['haproxy']['keepalived']['notify_email'] = 'you@yourorg.int'
default['cloudbees-cjp-ha']['haproxy']['keepalived']['smtp_gateway'] = 'localhost'
default['cloudbees-cjp-ha']['haproxy']['keepalived']['smtp_gw_timeout'] = '30'

##############################################################
# HAProxy Params                                             #
##############################################################
# haproxy checks
default['cloudbees-cjp-ha']['haproxy']['settings']['inter'] = '5s'
default['cloudbees-cjp-ha']['haproxy']['settings']['downinter'] = '500'
default['cloudbees-cjp-ha']['haproxy']['settings']['fastinter'] = '500'
default['cloudbees-cjp-ha']['haproxy']['settings']['rise'] = '1'
default['cloudbees-cjp-ha']['haproxy']['settings']['fall'] = '1'

# jnlp ports are common to each cluster and MANUALLY SET in the Jenkins Security interface.
default['cloudbees-cjp-ha']['haproxy']['hosts']['opcenter']['jnlp_port'] = '50001'
default['cloudbees-cjp-ha']['haproxy']['hosts']['master']['jnlp_port'] = '50000'

# define cluster nodes
default['cloudbees-cjp-ha']['haproxy']['hosts']['opcenter']['pri_ip'] = '192.168.254.20'
default['cloudbees-cjp-ha']['haproxy']['hosts']['opcenter']['sec_ip'] = '192.168.254.21'
default['cloudbees-cjp-ha']['haproxy']['hosts']['master']['pri_ip'] = '192.168.254.30'
default['cloudbees-cjp-ha']['haproxy']['hosts']['master']['sec_ip'] = '192.168.254.31'

default['cloudbees-cjp-ha']['haproxy']['settings']['stats_enable'] = 'enable' # enable || disable
default['cloudbees-cjp-ha']['haproxy']['settings']['stats_refresh'] = '5s'
default['cloudbees-cjp-ha']['haproxy']['settings']['stats_user'] = 'admin'
default['cloudbees-cjp-ha']['haproxy']['settings']['stats_pass'] = 'admin'

##############################################################
# Cloudbees Jenkins Operations Center                        #
##############################################################
default['cloudbees-cjp-ha']['opcenter']['package']['version'] = '2.303.2.6'

# max files is for jenkins, not the system.
default['cloudbees-cjp-ha']['opcenter']['jenkins-oc']['max_open_files'] = '8192'

# this is the backhaul port -- standard at 8080.
default['cloudbees-cjp-ha']['opcenter']['jenkins-oc']['http_port'] = '8080'

# the nfs recipe is to facilitate KitchenCI. Bring your own nfs cookbook.
default['cloudbees-cjp-ha']['opcenter']['nfs_mount']['device'] = '192.168.254.250:/mnt/exports/jenkins-oc'
default['cloudbees-cjp-ha']['opcenter']['nfs_mount']['fstype'] = 'nfs'
default['cloudbees-cjp-ha']['opcenter']['nfs_mount']['options'] = 'intr,rw,nfsvers=3,sec=sys,tcp,hard,timeo=300,_netdev'

# multicast is used for the high-availablity function in Cloudbees CJP.
default['cloudbees-cjp-ha']['opcenter']['ip4_multicast']['interface'] = 'enp0s8'

##############################################################
# Cloudbees Jenkins Client Master                            #
##############################################################
default['cloudbees-cjp-ha']['master']['package']['version'] = '2.303.2.6'

# max files is for jenkins, not the system.
default['cloudbees-cjp-ha']['master']['jenkins']['max_open_files'] = '8192'

# this is the backhaul port -- standard at 8080.
default['cloudbees-cjp-ha']['master']['jenkins']['http_port'] = '8080'

# the nfs recipe is to facilitate KitchenCI. Bring your own nfs cookbook.
default['cloudbees-cjp-ha']['master']['nfs_mount']['device'] = '192.168.254.250:/mnt/exports/jenkins'
default['cloudbees-cjp-ha']['master']['nfs_mount']['fstype'] = 'nfs'
default['cloudbees-cjp-ha']['master']['nfs_mount']['options'] = 'intr,rw,nfsvers=3,sec=sys,tcp,hard,timeo=300,_netdev'

# multicast is used for the high-availablity function in Cloudbees CJP.
default['cloudbees-cjp-ha']['master']['ip4_multicast']['interface'] = 'enp0s8'

##############################################################
# Universal Attributes -- Used across all recipes/nodes      #
##############################################################
# apparmor - must be disabled.
override['apparmor']['disable'] = true
