# encoding: utf-8
require 'helper'

describe T::CLI::List::Remove::All do

  before do
    @t = T::CLI.new
    @old_stderr = $stderr
    $stderr = StringIO.new
    @old_stdout = $stdout
    $stdout = StringIO.new
  end

  after do
    $stderr = @old_stderr
    $stdout = @old_stdout
  end

  describe "#friends" do
    before do
      @t.options = @t.options.merge(:profile => fixture_path + "/.trc")
      stub_get("/1/account/verify_credentials.json").
        to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    context "no users" do
      before do
        stub_get("/1/lists/members.json").
          with(:query => {:cursor => "-1", :include_entities => "false", :owner_screen_name => "sferik", :skip_status => "true", :slug => "presidents"}).
          to_return(:body => fixture("empty_cursor.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1/friends/ids.json").
          with(:query => {:cursor => "-1"}).
          to_return(:body => fixture("empty_cursor.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "should request the correct resource" do
        @t.list("remove", "all", "friends", "presidents")
        a_get("/1/friends/ids.json").
          with(:query => {:cursor => "-1"}).
          should have_been_made
      end
      it "should have the correct output" do
        @t.list("remove", "all", "friends", "presidents")
        $stdout.string.chomp.should == "None of @testcli's friends are members of the list \"presidents\"."
      end
    end
    context "one user" do
      before do
        stub_get("/1/lists/members.json").
          with(:query => {:cursor => "-1", :include_entities => "false", :owner_screen_name => "sferik", :skip_status => "true", :slug => "presidents"}).
          to_return(:body => fixture("empty_cursor.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1/friends/ids.json").
          with(:query => {:cursor => "-1"}).
          to_return(:body => fixture("friends_ids.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_post("/1/lists/members/destroy.json").
          with(:body => {:user_id => "7505382", :slug => "presidents", :owner_screen_name => "sferik"}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "should request the correct resource" do
        $stdout.should_receive(:print).with("Are you sure you want to remove 1 friend from the list \"presidents\"? ")
        $stdin.should_receive(:gets).and_return("yes")
        @t.list("remove", "all", "friends", "presidents")
        a_get("/1/account/verify_credentials.json").
          should have_been_made
        a_get("/1/lists/members.json").
          with(:query => {:cursor => "-1", :include_entities => "false", :owner_screen_name => "sferik", :skip_status => "true", :slug => "presidents"}).
          should have_been_made
        a_get("/1/friends/ids.json").
          with(:query => {:cursor => "-1"}).
          should have_been_made
        a_post("/1/lists/members/destroy.json").
          with(:body => {:user_id => "7505382", :slug => "presidents", :owner_screen_name => "sferik"}).
          should have_been_made
      end
      context "yes" do
        it "should have the correct output" do
          $stdout.should_receive(:print).with("Are you sure you want to remove 1 friend from the list \"presidents\"? ")
          $stdin.should_receive(:gets).and_return("yes")
          @t.list("remove", "all", "friends", "presidents")
          $stdout.string.should =~ /@testcli removed 1 friend from the list "presidents"\./
        end
      end
      context "no" do
        it "should have the correct output" do
          $stdout.should_receive(:print).with("Are you sure you want to remove 1 friend from the list \"presidents\"? ")
          $stdin.should_receive(:gets).and_return("no")
          @t.list("remove", "all", "friends", "presidents")
          $stdout.string.chomp.should == ""
        end
      end
    end
  end

  describe "#followers" do
    before do
      @t.options = @t.options.merge(:profile => fixture_path + "/.trc")
      stub_get("/1/account/verify_credentials.json").
        to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    context "no users" do
      before do
        stub_get("/1/lists/members.json").
          with(:query => {:cursor => "-1", :include_entities => "false", :owner_screen_name => "sferik", :skip_status => "true", :slug => "presidents"}).
          to_return(:body => fixture("empty_cursor.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1/followers/ids.json").
          with(:query => {:cursor => "-1"}).
          to_return(:body => fixture("empty_cursor.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "should request the correct resource" do
        @t.list("remove", "all", "followers", "presidents")
        a_get("/1/followers/ids.json").
          with(:query => {:cursor => "-1"}).
          should have_been_made
      end
      it "should have the correct output" do
        @t.list("remove", "all", "followers", "presidents")
        $stdout.string.chomp.should == "None of @testcli's followers are members of the list \"presidents\"."
      end
    end
    context "one user" do
      before do
        stub_get("/1/lists/members.json").
          with(:query => {:cursor => "-1", :include_entities => "false", :owner_screen_name => "sferik", :skip_status => "true", :slug => "presidents"}).
          to_return(:body => fixture("empty_cursor.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1/followers/ids.json").
          with(:query => {:cursor => "-1"}).
          to_return(:body => fixture("followers_ids.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_post("/1/lists/members/destroy.json").
          with(:body => {:user_id => "213747670", :slug => "presidents", :owner_screen_name => "sferik"}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_post("/1/lists/members/destroy.json").
          with(:body => {:user_id => "428004849", :slug => "presidents", :owner_screen_name => "sferik"}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "should request the correct resource" do
        $stdout.should_receive(:print).with("Are you sure you want to remove 2 followers from the list \"presidents\"? ")
        $stdin.should_receive(:gets).and_return("yes")
        @t.list("remove", "all", "followers", "presidents")
        a_get("/1/account/verify_credentials.json").
          should have_been_made
        a_get("/1/lists/members.json").
          with(:query => {:cursor => "-1", :include_entities => "false", :owner_screen_name => "sferik", :skip_status => "true", :slug => "presidents"}).
          should have_been_made
        a_get("/1/followers/ids.json").
          with(:query => {:cursor => "-1"}).
          should have_been_made
        a_post("/1/lists/members/destroy.json").
          with(:body => {:user_id => "213747670", :slug => "presidents", :owner_screen_name => "sferik"}).
          should have_been_made
        a_post("/1/lists/members/destroy.json").
          with(:body => {:user_id => "428004849", :slug => "presidents", :owner_screen_name => "sferik"}).
          should have_been_made
      end
      context "yes" do
        it "should have the correct output" do
          $stdout.should_receive(:print).with("Are you sure you want to remove 2 followers from the list \"presidents\"? ")
          $stdin.should_receive(:gets).and_return("yes")
          @t.list("remove", "all", "followers", "presidents")
          $stdout.string.should =~ /@testcli removed 2 followers from the list "presidents"\./
        end
      end
      context "no" do
        it "should have the correct output" do
          $stdout.should_receive(:print).with("Are you sure you want to remove 2 followers from the list \"presidents\"? ")
          $stdin.should_receive(:gets).and_return("no")
          @t.list("remove", "all", "followers", "presidents")
          $stdout.string.chomp.should == ""
        end
      end
    end
  end

  describe "#listed" do
    before do
      @t.options = @t.options.merge(:profile => fixture_path + "/.trc")
      stub_get("/1/account/verify_credentials.json").
        to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    context "no users" do
      before do
        stub_get("/1/lists/members.json").
          with(:query => {:cursor => "-1", :include_entities => "false", :owner_screen_name => "sferik", :skip_status => "true", :slug => "presidents"}).
          to_return(:body => fixture("empty_cursor.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1/lists/members.json").
          with(:query => {:cursor => "-1", :include_entities => "false", :owner_screen_name => "sferik", :skip_status => "true", :slug => "democrats"}).
          to_return(:body => fixture("empty_cursor.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "should request the correct resource" do
        @t.list("remove", "all", "listed", "democrats", "presidents")
        a_get("/1/account/verify_credentials.json").
          should have_been_made
        a_get("/1/lists/members.json").
          with(:query => {:cursor => "-1", :include_entities => "false", :owner_screen_name => "sferik", :skip_status => "true", :slug => "presidents"}).
          should have_been_made
        a_get("/1/lists/members.json").
          with(:query => {:cursor => "-1", :include_entities => "false", :owner_screen_name => "sferik", :skip_status => "true", :slug => "democrats"}).
          should have_been_made
      end
      it "should have the correct output" do
        @t.list("remove", "all", "listed", "democrats", "presidents")
        $stdout.string.chomp.should == "None of the members of the list \"democrats\" are members of the list \"presidents\"."
      end
    end
    context "one user" do
      before do
        stub_get("/1/lists/members.json").
          with(:query => {:cursor => "-1", :include_entities => "false", :owner_screen_name => "sferik", :skip_status => "true", :slug => "presidents"}).
          to_return(:body => fixture("empty_cursor.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1/lists/members.json").
          with(:query => {:cursor => "-1", :include_entities => "false", :owner_screen_name => "sferik", :skip_status => "true", :slug => "democrats"}).
          to_return(:body => fixture("users_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_post("/1/lists/members/destroy.json").
          with(:body => {:user_id => "7505382", :slug => "presidents", :owner_screen_name => "sferik"}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "should request the correct resource" do
        $stdout.should_receive(:print).with("Are you sure you want to remove 1 member from the list \"presidents\"? ")
        $stdin.should_receive(:gets).and_return("yes")
        @t.list("remove", "all", "listed", "democrats", "presidents")
        a_get("/1/account/verify_credentials.json").
          should have_been_made
        a_get("/1/lists/members.json").
          with(:query => {:cursor => "-1", :include_entities => "false", :owner_screen_name => "sferik", :skip_status => "true", :slug => "presidents"}).
          should have_been_made
        a_get("/1/lists/members.json").
          with(:query => {:cursor => "-1", :include_entities => "false", :owner_screen_name => "sferik", :skip_status => "true", :slug => "democrats"}).
          should have_been_made
        a_post("/1/lists/members/destroy.json").
          with(:body => {:user_id => "7505382", :slug => "presidents", :owner_screen_name => "sferik"}).
          should have_been_made
      end
      context "yes" do
        it "should have the correct output" do
          $stdout.should_receive(:print).with("Are you sure you want to remove 1 member from the list \"presidents\"? ")
          $stdin.should_receive(:gets).and_return("yes")
          @t.list("remove", "all", "listed", "democrats", "presidents")
          $stdout.string.should =~ /@testcli removed 1 member from the list "presidents"\./
        end
      end
      context "no" do
        it "should have the correct output" do
          $stdout.should_receive(:print).with("Are you sure you want to remove 1 member from the list \"presidents\"? ")
          $stdin.should_receive(:gets).and_return("no")
          @t.list("remove", "all", "listed", "democrats", "presidents")
          $stdout.string.chomp.should == ""
        end
      end
    end
  end

  describe "#members" do
    before do
      @t.options = @t.options.merge(:profile => fixture_path + "/.trc")
      stub_get("/1/account/verify_credentials.json").
        to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    context "no users" do
      before do
        stub_get("/1/lists/members.json").
          with(:query => {:cursor => "-1", :include_entities => "false", :owner_screen_name => "sferik", :skip_status => "true", :slug => "presidents"}).
          to_return(:body => fixture("empty_cursor.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "should request the correct resource" do
        @t.list("remove", "all", "members", "presidents")
        a_get("/1/account/verify_credentials.json").
          should have_been_made
        a_get("/1/lists/members.json").
          with(:query => {:cursor => "-1", :include_entities => "false", :owner_screen_name => "sferik", :skip_status => "true", :slug => "presidents"}).
          should have_been_made
      end
      it "should have the correct output" do
        @t.list("remove", "all", "members", "presidents")
        $stdout.string.chomp.should == "The list \"presidents\" doesn't have any members."
      end
    end
    context "one user" do
      before do
        stub_get("/1/lists/members.json").
          with(:query => {:cursor => "-1", :include_entities => "false", :owner_screen_name => "sferik", :skip_status => "true", :slug => "presidents"}).
          to_return(:body => fixture("users_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_post("/1/lists/members/destroy.json").
          with(:body => {:user_id => "7505382", :slug => "presidents", :owner_screen_name => "sferik"}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "should request the correct resource" do
        $stdout.should_receive(:print).with("Are you sure you want to remove 1 member from the list \"presidents\"? ")
        $stdin.should_receive(:gets).and_return("yes")
        @t.list("remove", "all", "members", "presidents")
        a_get("/1/account/verify_credentials.json").
          should have_been_made
        a_get("/1/lists/members.json").
          with(:query => {:cursor => "-1", :include_entities => "false", :owner_screen_name => "sferik", :skip_status => "true", :slug => "presidents"}).
          should have_been_made
        a_post("/1/lists/members/destroy.json").
          with(:body => {:user_id => "7505382", :slug => "presidents", :owner_screen_name => "sferik"}).
          should have_been_made
      end
      context "yes" do
        it "should have the correct output" do
          $stdout.should_receive(:print).with("Are you sure you want to remove 1 member from the list \"presidents\"? ")
          $stdin.should_receive(:gets).and_return("yes")
          @t.list("remove", "all", "members", "presidents")
          $stdout.string.should =~ /@testcli removed 1 member from the list "presidents"\./
        end
      end
      context "no" do
        it "should have the correct output" do
          $stdout.should_receive(:print).with("Are you sure you want to remove 1 member from the list \"presidents\"? ")
          $stdin.should_receive(:gets).and_return("no")
          @t.list("remove", "all", "members", "presidents")
          $stdout.string.chomp.should == ""
        end
      end
    end
  end

end
