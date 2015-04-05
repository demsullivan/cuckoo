require 'spec_helper'

shared_context 'commands' do
  include Cuckoo::Commands
end

describe Cuckoo::CommandInput do

  extend Cuckoo::Commands

  # before(:all) do

  #   StopCommand       = class_double("StopCommand", :call => nil)
  #   AddNoteCommand    = class_double("AddNoteCommand", :call => nil)
  #   IRBCommand        = class_double("IRBCommand", :call => nil)
  #   NewTaskCommand    = class_double("NewTaskCommand", :call => nil)
  #   UpdateTaskCommand = class_double("UpdateTaskCommand", :call => nil)
  # end

  before(:each) { @context = Cuckoo::Context.new }
  before(:all) { include Cuckoo::Commands }
  
  it "should call the 'create' command" do
    expect_any_instance_of(CreateCommand).to receive(:call)
    cmd = described_class.new("create test", @context)
    cmd.execute!
  end

  it "should call the 'status' command" do
    expect_any_instance_of(Cuckoo::Commands::StatusCommand).to 
    StatusCommand = class_double("StatusCommand", :call => nil)
    expect(StatusCommand).to receive(:call)
    cmd = described_class.new("status", @context)
  end

  it "should call the 'stop' command" do
    StopCommand = class_double(:call => nil)
    expect(StopCommand).to receive(:call)
    cmd = described_class.new("stop", @context)
  end

  it "should call the 'note' command" do
    expect(AddNoteCommand).to receive(:call)
    cmd = described_class.new("note some random text", @context)
  end

  it "should call the 'irb' command" do
    expect(IRBCommand).to receive(:call)
    cmd = described_class.new("irb", @context)
  end

  it "should call the 'new task' command" do
    expect(NewTaskCommand).to receive(:call)
    cmd = described_class.new("@project #123 task name #development")
  end

  it "should call the 'update task' command" do
    expect(UpdateTaskCommand).to receive(:call)
    cmd = described_class.new("@project #123 task name for 15 minutes at 4pm")
  end
end
