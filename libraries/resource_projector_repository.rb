require 'chef/resource'

class Chef
  class Resource
    class ProjectorRepository < Chef::Resource

      identity_attr :repository_path
      provides :projector_repository, :on_platforms => :all

      def initialize(name, run_context=nil)
        super
        defaults = attrs_from_node(run_context)
        
        @resource_name = :projector_repository
        @provider = Chef::Provider::ProjectorRepository
        @action = :create

        @org = defaults['org']
        @repo = "#{org}/#{name}"
        @description = ''
        @connection = defaults['connection'] || {}
        # XXX
        @queue = defaults['queue'] || {}
        @hooks = defaults['hooks'] || {}
        @exists = false
      end

      def repo(arg=nil)
        set_or_return(:repository_path, arg, :kind_of => [String])
      end

      def org(arg=nil)
        set_or_return(:org, arg, :kind_of => [String])
      end

      def description(arg=nil)
        set_or_return(:description, arg, :kind_of => [String])
      end

      def connection(arg=nil)
        set_or_return(:connection, arg, :kind_of => [Hash])
      end

      def queue(arg=nil)
        set_or_return(:queue, arg, :kind_of => [Hash])
      end

      def hooks(arg=nil)
        set_or_return(:hooks, arg, :kind_of => [Hash])
      end

      def exists(arg=nil)
        set_or_return(:exists, arg, :kind_of => [Boolean])
      end

      private

      def attrs_from_node(run_context)
        attrs = if run_context && run_context.node
                  run_context.node[:projector]
                end
        (attrs || {})[:repository]
      end

    end
  end
end
