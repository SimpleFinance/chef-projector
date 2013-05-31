chef_gem 'octokit' do
  action :install
end

data_bag(node['projector']['databag']).each do |item|

  repo = projector_repository item['id'] do
    action :create
    org item['org']
    description item['description']
    # XXX: irc, etc
    # hooks
  end

  targets = item['targets'].len
  item['targets'].each_with_index do |target, i|
    job_name = "#{item['id']}-#{target}"
    projector_job job_name do
      command item['command']
      target target
      description item['description']
      repository repo
      queue 'XXX'
      variables(
        :index => i,
        :targets => targets
      )
    end
  end
end
