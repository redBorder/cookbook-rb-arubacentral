action :add do
  begin
    logdir = new_resource.logdir
    configdir = new_resource.configdir
    user = new_resource.user
    group = new_resource.group
    arubacentral_nodes = new_resource.arubacentral_nodes
    flow_nodes = new_resource.flow_nodes
    kafka_brokers = new_resource.kafka_brokers

    dnf_package 'rb-arubacentral' do
      action :upgrade
      flush_cache [ :before ]
    end

    execute 'create_user' do
      command "/usr/sbin/useradd #{user}"
      ignore_failure true
      not_if "getent passwd #{user}"
    end

    directory logdir do
      owner user
      group group
      mode '0770'
      action :create
    end

    directory configdir do
      owner user
      group group
      mode '0700'
      action :create
    end

    template configdir+'/config.yml' do
      source 'config.erb'
      owner user
      group group
      mode '0644'
      cookbook 'rb-arubacentral'
      variables(
        arubacentral_nodes: arubacentral_nodes,
        flow_nodes: flow_nodes,
        kafka_brokers: kafka_brokers
      )
      notifies :restart, 'service[rb-arubacentral]', :delayed
    end

    service 'rb-arubacentral' do
      service_name 'rb-arubacentral'
      supports status: true, reload: true, restart: true, start: true, enable: true
      action [:enable, :start]
    end

    Chef::Log.info('rb-arubacentral has been configured correctly.')
  rescue => e
    Chef::Log.error(e.message)
  end
end

action :remove do
  begin
    service 'rb-arubacentral' do
      supports stop: true, disable: true
      action [:stop, :disable]
    end

    Chef::Log.info('rb-arubacentral has been stoppedand disabled correctly.')
  rescue => e
    Chef::Log.error(e.message)
  end
end
