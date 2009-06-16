module Whenever
  module Job
    class Default
      
      attr_accessor :task, :at, :cron_log, :no_stderr_redirect
    
      def initialize(options = {})
        @task        = options[:task]
        @at          = options[:at]
        @cron_log    = options[:cron_log]
        @no_stderr_redirect = options[:no_stderr_redirect]
        @environment = options[:environment] || :production
        @path        = options[:path] || Whenever.path
      end
    
      def output
        task
      end
      
    protected
      
      def path_required
        raise ArgumentError, "No path available; set :path, '/your/path' in your schedule file" if @path.blank?
      end
      
    end
  end
end