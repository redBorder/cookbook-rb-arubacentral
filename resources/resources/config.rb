# Cookbook:: rb-arubacentral
#
# Resource:: config
#

unified_mode true
actions :add, :remove
default_action :add

attribute :logdir, kind_of: String, default: '/var/log/rb-arubacentral'
attribute :configdir, kind_of: String, default: '/etc/rb-arubacentral'
attribute :user, kind_of: String, default: 'rb-arubacentral'
attribute :group, kind_of: String, default: 'rb-arubacentral'
attribute :arubacentral_nodes, kind_of: Array, default: []
attribute :flow_nodes, kind_of: Array, default: []
attribute :kafka_brokers, kind_of: Array, default: ['kafka.service']
attribute :ipaddress, kind_of: String, default: '127.0.0.1'
