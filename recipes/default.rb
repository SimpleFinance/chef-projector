chef_gem 'octokit' do
  action :install
end

data_bag(node['projector']['databag']).each do |item|

  projector_repository item['id'] do
    # XXX
  end

  item['targets'].each do |target|
    job_name = "#{item['id']}-#{target}"
    projector_job job_name do
      command item['command']
    end
  end
end
