require 'chef/resource'

class Chef
  class Resource
    class ProjectorJob < Chef::Resource

      identity_attr :job_name
      provides :projector_job, :on_platforms => :all

      def initialize(name, run_context=nil)
        super
        defaults = attrs_from_node(run_context)
        @resource_name = :projector_job
        @provider = Chef::Provider::ProjectorJob
        @action = :create
        @allowed_actions = [:create, :update, :delete]
        
        @make = defaults['make'] || 'make'
        @target = defaults['target'] || 'build'
        @owner = defaults['owner'] || 'projector'
        @group = defaults['group'] || 'projector'
        @template = defaults['template'] || 'config.xml.erb'
        @variables = Hash.new
        @description = ''
        @cookbook = nil
        @url = nil
        @repository = nil

        # XXX
        @queue = defaults['queue'] || {}

        @job_name = "#{name}-#{@target}"
      end

      def make(arg=nil)
        set_or_return(:make, arg, :kind_of => [String])
      end

      def owner(arg=nil)
        set_or_return(:owner, arg, :kind_of => [String])
      end

      def group(arg=nil)
        set_or_return(:group, arg, :kind_of => [String])
      end

      def description(arg=nil)
        set_or_return(:description, arg, :kind_of => [String])
      end

      def template(arg=nil)
        set_or_return(:template, arg, :kind_of => [String])
      end

      def variables(arg=nil)
        set_or_return(:variables, arg, :kind_of => [Hash])
      end

      def cookbook(arg=nil)
        set_or_return(:cookbook, arg, :kind_of => [String])
      end

      def job_name(arg=nil)
        set_or_return(:job_name, arg, :kind_of => [String])
      end

      def target(arg=nil)
        set_or_return(:target, arg, :kind_of => [String])
      end

      def url(arg=nil)
        set_or_return(:url, arg, :kind_of => [String])
      end

      def repository(arg=nil)
        set_or_return(:repository, arg, :kind_of => [String])
      end

      def queue(arg=nil)
        set_or_return(:queue, arg, :kind_of => [Hash])
      end

      private

      def attrs_from_node(run_context)
        attrs = if run_context && run_context.node
                  run_context.node[:projector]
                end
        (attrs || {})[:job]
      end

    end
  end
end
