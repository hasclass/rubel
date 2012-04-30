require 'spec_helper'

describe do
  it "should spec" do
    true.should be_true
  end

  context "Runtime::Loader" do
    after do
      ENV['RAILS_ENV'] = 'test'
    end

    it "should load Sandbox in test" do
      ENV['RAILS_ENV'] = 'test'
      Rubel::Runtime::Loader.runtime.should == Rubel::Runtime::Sandbox
    end
    it "should load Sandbox in production" do
      ENV['RAILS_ENV'] = 'production'
      Rubel::Runtime::Loader.runtime.should == Rubel::Runtime::Sandbox
    end
    it "should load Console in development" do
      ENV['RAILS_ENV'] = 'development'
      Rubel::Runtime::Loader.runtime.should == Rubel::Runtime::Console
    end
  end

  context "default" do
    before do
      ENV['RAILS_ENV'] = 'test'
      @rubel = Rubel::Base.new
    end

    def execute(obj)
      @rubel.execute(obj)
    end

    it 'should execute "SUM(1,2,3)"' do
      execute("SUM(1,2,3)").should == 6
    end

    it "should execute lambda { SUM(1,2,3) }" do
      execute(lambda { SUM(1,2,3) }).should == 6
    end

    it "should execute Proc.new { SUM(1,2,3) }" do
      execute(Proc.new { SUM(1,2,3) }).should == 6
    end

    it "should execute" do
      execute("5.124.round(SUM(1))").should == 5.1
    end

    it "should execute MAP" do
      execute("MAP([5.124], round(SUM(1)))").should == 5.1
    end

    pending do
      # Disabled block support. looks cool, but does not work
      # with method_missing, etc. So rather confusing.
      it "should execute as do SUM(1,2,3) end" do
        execute do 
          SUM(1,2,3)
        end.should == 6
      end
      
      it "should execute as { SUM(1,2,3) }" do
        execute{SUM(1,2,3)}.should == 6
      end
    end
  end

  context "sandbox" do
    before { @sandbox = Rubel::Runtime::Sandbox.new }
    it "should *not* restrict from accessing classes." do
      lambda {
        @sandbox.execute(-> { File.new })
      }.should_not raise_error(NameError)
    end

    it "should restrict from accessing classes" do
      lambda {
        @sandbox.new.execute('Kernel.puts("hacked")')
      }.should raise_error(NameError)
    end

    it "should restrict from accessing classes with ::" do
      lambda {
        @sandbox.new.execute('::Kernel.puts("hacked")')
      }.should raise_error(NameError)
    end

    it "should return symbols for method_missing" do
      @sandbox.execute(-> { foo }).should == :foo
    end
  end


end