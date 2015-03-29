require 'spec_helper'

describe Cuckoo::CommandInput do

  PROJECT = "@project"
  TAG     = "#development"
  TASK    = "build new reports"
  PTT = "#{PROJECT} #{TAG} #{TASK}"
  NEW_TASK_WITH_ESTIMATE          = "#{PTT} in 2h?"
  RETROACTIVE_TASK_T_BEFORE_D = "#{PTT} at 4pm for 30 minutes"
  RETROACTIVE_TASK_D_BEFORE_T = "#{PTT} for 30 minutes at 4pm"
  RETROACTIVE_TASK_ON_T_BEFORE_D = "#{PTT} on Friday at 4pm for 30 minutes"
  RETROACTIVE_TASK_ON_D_BEFORE_T = "#{PTT} for 30 minutes on Friday at 4pm"
  RETROACTIVE_TASK_LAST_T_BEFORE_D = "#{PTT} last Saturday at 4pm for 30 minutes"
  RETROACTIVE_TASK_LAST_D_BEFORE_T = "#{PTT} for 30 minutes last Saturday at 4pm"
  RETROACTIVE_TASK_YEST_T_BEFORE_D = "#{PTT} yesterday at 4pm for 30 minutes"
  RETROACTIVE_TASK_YEST_D_BEFORE_T = "#{PTT} for 30 minutes yesterday at 4pm"
  MULTI_TAG         = "#{PROJECT} #testing #unbillable #{TASK}"

  shared_examples_for "a retroactively added task" do |text|
    let(:context) { Cuckoo::Context.new }
    subject { Cuckoo::CommandInput.new(text, context) }

    it "should parse projects" do
      expect(subject.context.project).to be PROJECT
    end

    it "should parse tags" do
      expect(subject.context.tags).to be [TAG]
    end

    it "should parse task name" do
      expect(subject.context.task_name).to be TASK
    end

    it "should parse duration" do
      expect(subject.context.duration).to be 1800
    end

    it "should parse the date and time" do
      expect(true).to be true
    end
  end

  context "time before duration using 'at'" do
    it_should_behave_like "a retroactively added task", RETROACTIVE_T_BEFORE_D
  end

  context "duration before time using 'at'" do
    it_should_behave_like "a retroactively added task", RETROACTIVE_D_BEFORE_T
  end

  
  context "time before duration using 'on'" do
    it_should_behave_like "a retroactively added task", RETROACTIVE_ON_T_BEFORE_D
  end

  context "duration before time using 'on'" do
    it_should_behave_like "a retroactively added task", RETROACTIVE_ON_D_BEFORE_T
  end

  
  context "time before duration using 'last'" do
    it_should_behave_like "a retroactively added task", RETROACTIVE_LAST_T_BEFORE_D
  end

  context "duration before time using 'last'" do
    it_should_behave_like "a retroactively added task", RETROACTIVE_LAST_D_BEFORE_T
  end

  
  context "time before duration using 'yesterday'" do
    it_should_behave_like "a retroactively added task", RETROACTIVE_YEST_T_BEFORE_D
  end

  context "duration before time using 'yesterday'" do
    it_should_behave_like "a retroactively added task", RETROACTIVE_YEST_BEFORE_T
  end
end
