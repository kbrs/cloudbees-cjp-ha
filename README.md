# cloudbees-cjp-ha

### Cloudbees Jenkins Platform 2x

* Cloudbees Jenkins Platform (CJP) (Default: 2.73.1.2)
* Deploy Strategy: High-Availability
* CJP Strategy: Multi-master (single included)

### Supported Platforms

* Ubuntu 14.04

### Usage

#### Local Testing

This cookbook will come up in KitchenCI using Vagrant and Ubuntu-14.04 boxes. Cloudbees license locks their product so when finished, all necessary services will have been 'stood up' and ready for human intervention. Because of that, there are manual steps that need to be performed post-cookbook:
> * Unlock & License Cloudbees nodes
> * Set the site URL in the Manage Jenkins dialog
> * Set the JNLP ports as spec'd in attributes/default.rb in the Jenkins Security dialog

Once created, you can use the following addresses to access the services:
* [HAProxy Stats](http://192.168.254.10:8001/stats)
* [Cloudbees Operations Center](http://192.168.254.10/operations-center/)
* [Cloudbees Jenkins Enterprise](http://192.168.254.10/ha-master/)

```
berks install && berks update
kitchen create && kitchen converge
```

#### For Deployment

* Edit attributes/default.rb or wrap with your own cookbook
* Include `cloudbees-cjp-ha` in your node's `run_list`:

#### Supporting Infra - NFS

##### cloudbees-cjp-ha::nfs

```json
{
  "run_list": [
    "recipe[cloudbees-cjp-ha::nfs]"
  ]
}
```

#### HAProxy

##### cloudbees-cjp-ha::haproxy

```json
{
  "run_list": [
    "recipe[cloudbees-cjp-ha::haproxy]"
  ]
}
```

#### Cloudbees Operations Center (CJOC)

##### cloudbees-cjp-ha::opcenter

```json
{
  "run_list": [
    "recipe[cloudbees-cjp-ha::opcenter]"
  ]
}
```

#### Jenkins Client Master (CJE)

##### cloudbees-cjp-ha::master

```json
{
  "run_list": [
    "recipe[cloudbees-cjp-ha::master]"
  ]
}
```

### License and Authors

**Author:: KickBack Rewards Systems** (ekolp@kickbackpoints.com)

#### GNU General Public License, version 2

Copyright 2017 [KickBack Rewards Systems](https://www.kickbacksystems.com)

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
