require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class CommandLineTest < Test::Unit::TestCase
  WHENEVER_CRON_CONTENTS = "Whenever CRON Contents"
  EXPECTED_WHENEVER_GENERATED_SEGMENT = CommandLine::START_MARKER + "\n" + WHENEVER_CRON_CONTENTS + "\n" + CommandLine::END_MARKER
  
  context "Some crontab to write" do
    setup do
      Whenever.stubs(:cron).returns(WHENEVER_CRON_CONTENTS)
      @command_line.stubs(:write_crontab).raises("Don't actually write the crontab, put an expectation on it!")
    end

    context "An empty crontab" do
      setup do
        @command_line = CommandLine.new
        @command_line.stubs(:read_crontab).returns("")
      end

      should "just write a fresh crontab" do
        @command_line.expects(:write_crontab).with(EXPECTED_WHENEVER_GENERATED_SEGMENT)
        @command_line.update!
      end
    end

    context "A crontab with some content" do
      setup do
        @command_line = CommandLine.new
        @command_line.stubs(:read_crontab).returns("Hello World")
      end

      should "Put the existing content at the top" do
        @command_line.expects(:write_crontab).with("Hello World\n" + EXPECTED_WHENEVER_GENERATED_SEGMENT)
        @command_line.update!
      end
    end

    context "A crontab with some content, and some existing whenever jobs" do
      setup do
        @command_line = CommandLine.new
        @command_line.stubs(:read_crontab).returns("Hello World\n#{CommandLine::START_MARKER}\nSome other old content to be overridden\n#{CommandLine::END_MARKER}")
      end

      should "Put the existing content at the top" do
        @command_line.expects(:write_crontab).with("Hello World\n" + EXPECTED_WHENEVER_GENERATED_SEGMENT)
        @command_line.update!
      end
    end


    context "A crontab with some content at the end, and some existing whenever jobs" do
      setup do
        @command_line = CommandLine.new
        @command_line.stubs(:read_crontab).returns("#{CommandLine::START_MARKER}\nSome other old content to be overridden\n#{CommandLine::END_MARKER}\nHello World")
      end

      should "Put the existing content at the top" do
        @command_line.expects(:write_crontab).with(EXPECTED_WHENEVER_GENERATED_SEGMENT + "\nHello World")
        @command_line.update!
      end
    end
  end

end
