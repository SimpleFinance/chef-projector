module Projector

  class Project

    attr_accessor :id

    def initialize(data)
      @data = data
    end

    def id
      @data['id']
    end

    def org
      @data['org']
    end

    def description
      @data['description']
    end

    def targets
      @data['targets'] || ['build']
    end
    
    def make
      @data['make'] || 'make'
    end

  end
end
