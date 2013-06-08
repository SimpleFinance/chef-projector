chef_gem 'octokit' do
  action :install
end

data_bag(node['projector']['databag']).each do |item|

  project = Projector::Project.new(item)

  repo = projector_repository project.id do
    action :create
    org project.org
    description project.description
    # XXX: irc, etc
    # hooks
  end

  targets = project.targets.length
  project.targets.each_with_index do |target, i|
    job_name = "#{project.id}-#{target}"
    projector_job job_name do
      make project.make
      target target
      description project.description
      repository repo.url
      queue {}
      variables(
        :index => i,
        :targets => targets
      )
    end
  end
end
