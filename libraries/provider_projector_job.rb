require 'chef/provider'

class Chef
  class Provider
    class ProjectorJob < Chef::Provider

      def initialize(*args)
        super
        @make = nil
        @config_dir = nil
        @config_template = nil
        @job = nil
      end

      def whyrun_supported?
        # XXX
        false
      end

      def load_current_resource
        @current_resource = Chef::Resource::ProjectorJob.new(@new_resource.name)
        @current_resource
      end

      def action_create
        config_dir.run_action(:create)
        config_template.run_action(:create)
        job.run_action(:create)

        updated = config_template.updated_by_last_action?
        @new_resource.updated_by_last_action(updated)
      end
      
      def action_update
        config_dir.run_action(:create)
        config_template.run_action(:create)
        updated = config_template.updated_by_last_action?
        if updated
          job.run_action(:create)
        end
        @new_resource.updated_by_last_action(updated)
      end

      def action_delete
        config_template.run_action(:delete)
        config_dir.run_action(:delete)
        updated = config_template.updated_by_last_action?
        if updated
          job.run_action(:delete)
        end
        @new_resource.updated_by_last_action(updated)
      end

      def config_dir_name
        ::File.join(new_resource.config_dir, new_resource.job_name)
      end

      def config_dir
        return @config_dir unless @config_dir.nil?
        
        @config_dir = Chef::Resource::Directory.new(config_dir_name, run_context)

        @config_dir.recursive(true)
        @config_dir.owner(new_resource.owner)
        @config_dir.group(new_resource.group)
        @config_dir.mode(00700)

        @config_dir
      end

      def config_template_name
        ::File.join(config_dir_name, 'config.xml')
      end

      def config_template
        return @config_template unless @config_template.nil?

        @config_template = Chef::Resource::Template.new(config_template_name, run_context)
        @config_template.cookbook(new_resource.cookbook)
        @config_template.source(new_resource.template)

        variables = {
                      :make => @make,
                      :description => @description,
                      :target => @target,
                      :repository => @repository,
                      :queue => @queue
                    }.merge(new_resource.variables)
        @config_template.variables(variables)
        @config_template.owner(new_resource.owner)
        @config_template.group(new_resource.group)
        @config_template.mode(00400)

        @config_template
      end

      def job
        return @job unless @job.nil?

        @job = Chef::Resource::JenkinsJob.new(new_resource.job_name, run_context)
        @job.config(config_template_name)
        @job.url(new_resource.url)

        @job
      end
    end
  end
end
