require 'chef/provider'

class Chef
  class Provider
    class ProjectorRepository < Chef::Provider

      def initialize(*args)
        super
      end

      def whyrun_supported?
        # XXX
        false
      end

      def load_current_resource
        @current_resource = Chef::Resource::ProjectorRepository.new(@new_resource.name)
        repo = client.repository(@new_resource.repo)
        @current_resource.exists(repo ? true : false)
        if repo
          @current_resource.repo(repo.slug)
          @current_resource.org(repo.username)
          @current_resource.description(repo.description)
          @current_resource.url(repo.url)
          hooks = {}
          client.hooks.each do |hook|
            hooks[hook.delete('name')] = hook
          end
          @current_resource.hooks(hooks)
        end
        
        @current_resource
      end

      def action_create
        if !@current_resource.exists
          client.create_repository(@new_resource.name,
                                    :organization => @new_resource.org,
                                    :description => @new_resource.description
                                    )

          hooks.each_pair do |service, config|
            client.create_hook(@new_resource.repo, service, config)
          end
        end
        @new_resource.updated_by_last_action(true)
      end

      def action_update
        updated = false
        
        if !@current_resource.exists
          action_create
          updated = true
        end

        options = {}
        %w{name description}.each do |attr|
          attr = attr.to_sym
          current = @current_resource.send(attr)
          new = @new_resource.send(attr)
          options[attr] = new if current != new
        end

        if !options.empty?
          # Use current_resource.repo here in case the name changes.
          client.edit_repository(@current_resource.repo, options)
          updated = true
        end

        # Use new_resource.repo from here on out in case the name changed.
        updated_hooks = []
        @current_resource.hooks.each_pair do |service, hook|
          config = hooks[service]
          if config.nil?
            client.remove_hook(@new_resource.repo, hook['id'])
            updated_hooks.push(service)
          else
            diff = config.select{|k,v| [v, nil].include?(hook[k])}
            if !diff.empty?
              client.edit_hook(@new_resource.repo, id, service, config)
              updated_hooks.push(service)
            end
          end
        end
        hooks.each_pair do |service, config|
          next if updated_hooks.include?(service)
          client.create_hook(@new_resource.repo, service, config)
          updated_hooks.push(service)
        end

        updated ||= !updated_hooks.empty?

        @new_resource.updated_by_last_action(updated)
      end
      
      def action_delete
        client.delete_repository(@new_resource.repo)
      end

      def hooks
        @new_resource.hooks.merge({'sqs'=>@new_resource.queue})
      end

      def url
        client.repository(@new_resource.repo).url
      end
      
      def client
        return @client unless @client.nil?
        
        conn = new_resource.connection.dup
        Octokit.configure do |c|
          c.api_endpoint = conn.delete('api_endpoint') || 'https://api.github.com/api/v3'
          c.web_endpoint = conn.delete('web_endpoint') || 'https://github.com/'
        end

        @client = Octokit::Client.new(conn)
      end

    end
  end
end
