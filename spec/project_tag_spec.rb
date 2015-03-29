require 'spec_helper'

describe Cuckoo::Project do
  NO_PROJECT_TEXT     = "#hashtag other stuff blah@blah".split(' ').map {|w| Cuckoo::Token.new(w) }
  SINGLE_PROJECT_TEXT = "@project this is a test #tag other@things".split(' ').map {|w| Cuckoo::Token.new(w) }
  MULTI_PROJECT_TEXT  = "@project @project2 this is a #test other@things".split(' ').map {|w| Cuckoo::Token.new(w) }


  it "should identify a single project" do
    tokens = SINGLE_PROJECT_TEXT
    Cuckoo::Project.scan(tokens)
    matches = tokens.select {|t| t.tags.include? :project}
    
    expect(matches.length).to eq 1
    expect(matches.first.word).to eq "@project"
  end

  it "should identify multiple projects" do
    tokens = MULTI_PROJECT_TEXT
    Cuckoo::Project.scan(tokens)
    matches = tokens.select {|t| t.tags.include? :project}

    expect(matches.length).to eq 2
    
    expect(matches.first.word).to eq "@project"
    expect(matches.last.word).to eq "@project2"
  end

  it "should identify nothing" do
    tokens = NO_PROJECT_TEXT
    Cuckoo::Project.scan(tokens)
    matches = tokens.select {|t| t.tags.include? :project}

    expect(matches.length).to eq 0
  end
end
    
