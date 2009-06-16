require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class OutputCommandTest < Test::Unit::TestCase
  
  context "A plain command" do
    setup do
      @output = Whenever.cron \
      <<-file
        every 2.hours do
          command "blahblah"
        end
      file
    end
    
    should "output the command" do
      assert_match /^.+ .+ .+ .+ blahblah$/, @output
    end
  end
  
  context "A command when the cron_log is set" do
    setup do
      @output = Whenever.cron \
      <<-file
        set :cron_log, 'logfile.log'
        every 2.hours do
          command "blahblah"
        end
      file
    end
    
    should "output the command with the log syntax appended" do
      assert_match /^.+ .+ .+ .+ blahblah >> logfile.log 2>&1$/, @output
    end
  end
  
  context "A command when the cron_log is set and the comand overrides it" do
    setup do
      @output = Whenever.cron \
      <<-file
        set :cron_log, 'logfile.log'
        every 2.hours do
          command "blahblah", :cron_log => 'otherlog.log'
        end
      file
    end
    
    should "output the command with the log syntax appended" do
      assert_no_match /.+ .+ .+ .+ blahblah >> logfile.log 2>&1/, @output
      assert_match /^.+ .+ .+ .+ blahblah >> otherlog.log 2>&1$/, @output
    end
  end
  
  context "A command when the cron_log is set and the comand rejects it" do
    setup do
      @output = Whenever.cron \
      <<-file
        set :cron_log, 'logfile.log'
        every 2.hours do
          command "blahblah", :cron_log => false
        end
      file
    end

    should "output the command without the log syntax appended" do
      assert_no_match /.+ .+ .+ .+ blahblah >> logfile.log 2>&1/, @output
      assert_match /^.+ .+ .+ .+ blahblah$/, @output
    end
  end
  
  context "A command when the cron_log is not set and the command line sets it instead" do
    setup do
      @output = Whenever.cron(
        :cron_log => "otherlog.log",
        :string => %%
            every 2.hours do
              command "blahblah"
            end
        %
      )
    end
    
    should "output the command with the log syntax appended" do
      assert_no_match /.+ .+ .+ .+ blahblah >> logfile.log 2>&1/, @output
      assert_match /^.+ .+ .+ .+ blahblah >> otherlog.log 2>&1$/, @output
    end
  end 
  
  context "A command when the cron_log is set and the no_stderr_redirect is set too" do
    setup do
      @output = Whenever.cron \
      <<-file
        set :cron_log, 'logfile.log'
        set :no_stderr_redirect, true
        every 2.hours do
          command "blahblah"
        end
      file
    end
    
    should "output the command with the log syntax appended but no error redirection" do
      assert_match /^.+ .+ .+ .+ blahblah >> logfile.log$/, @output
    end
  end        
  
  
  context "A command when the cron_log is set but no_stderr_redirect is set to false" do
    setup do
      @output = Whenever.cron \
      <<-file
        set :cron_log, 'logfile.log'
        set :no_stderr_redirect, false
        every 2.hours do
          command "blahblah"
        end
      file
    end
    
    should "output the command with the log syntax appended with error redirection" do
      assert_match /^.+ .+ .+ .+ blahblah >> logfile.log 2>&1$/, @output
    end
  end
       
  context "A command when cron_log and no_stderr_redirect are not set but the the command line sets them instead." do
    setup do
      @output = Whenever.cron(
        :cron_log => "otherlog.log",
        :no_stderr_redirect => true,
        :string => %%
            every 2.hours do
              command "blahblah"
            end
        %
      )
    end
    
    should "output the command with the log syntax appended but no error redirection" do
      assert_no_match /.+ .+ .+ .+ blahblah >> logfile.log/, @output
      assert_match /^.+ .+ .+ .+ blahblah >> otherlog.log$/, @output
    end
  end
end