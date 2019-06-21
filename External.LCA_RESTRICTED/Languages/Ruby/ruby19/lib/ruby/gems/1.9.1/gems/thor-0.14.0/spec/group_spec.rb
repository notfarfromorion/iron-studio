require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Thor::Group do
  describe "#start" do
    it "invokes all the tasks under the Thor group" do
      MyCounter.start(["1", "2", "--third", "3"]).must == [ 1, 2, 3 ]
    end

    it "uses argument default value" do
      MyCounter.start(["1", "--third", "3"]).must == [ 1, 2, 3 ]
    end

    it "invokes all the tasks in the Thor group and his parents" do
      BrokenCounter.start(["1", "2", "--third", "3"]).must == [ nil, 2, 3, false, 5 ]
    end

    it "raises an error if a required argument is added after a non-required" do
      lambda {
        MyCounter.argument(:foo, :type => :string)
      }.must raise_error(ArgumentError, 'You cannot have "foo" as required argument after the non-required argument "second".')
    end

    it "raises when an exception happens within the task call" do
      lambda { BrokenCounter.start(["1", "2", "--fail"]) }.must raise_error
    end

    it "raises an error when a Thor group task expects arguments" do
      lambda { WhinyGenerator.start }.must raise_error(ArgumentError, /Are you sure it has arity equals to 0\?/)
    end

    it "invokes help message if any of the shortcuts is given" do
      MyCounter.should_receive(:help)
      MyCounter.start(["-h"])
    end
  end

  describe "#desc" do
    it "sets the description for a given class" do
      MyCounter.desc.must == "Description:\n  This generator runs three tasks: one, two and three.\n"
    end

    it "can be inherited" do
      BrokenCounter.desc.must == "Description:\n  This generator runs three tasks: one, two and three.\n"
    end

    it "can be nil" do
      WhinyGenerator.desc.must be_nil
    end
  end

  describe "#help" do
    before(:each) do
      @content = capture(:stdout){ MyCounter.help(Thor::Base.shell.new) }
    end

    it "provides usage information" do
      @content.must =~ /my_counter N \[N\]/
    end

    it "shows description" do
      @content.must =~ /Description:/
      @content.must =~ /This generator runs three tasks: one, two and three./
    end

    it "shows options information" do
      @content.must =~ /Options/
      @content.must =~ /\[\-\-third=THREE\]/
    end
  end

  describe "#invoke" do
    before(:each) do
      @content = capture(:stdout){ E.start }
    end

    it "allows to invoke a class from the class binding" do
      @content.must =~ /1\n2\n3\n4\n5\n/
    end

    it "shows invocation information to the user" do
      @content.must =~ /invoke  Defined/
    end

    it "uses padding on status generated by the invoked class" do
      @content.must =~ /finished    counting/
    end

    it "allows invocation to be configured with blocks" do
      capture(:stdout) do
        F.start.must == ["Valim, Jose"]
      end
    end

    it "shows invoked options on help" do
      content = capture(:stdout){ E.help(Thor::Base.shell.new) }
      content.must =~ /Defined options:/
      content.must =~ /\[--unused\]/
      content.must =~ /# This option has no use/
    end
  end

  describe "#invoke_from_option" do
    describe "with default type" do
      before(:each) do
        @content = capture(:stdout){ G.start }
      end

      it "allows to invoke a class from the class binding by a default option" do
        @content.must =~ /1\n2\n3\n4\n5\n/
      end

      it "does not invoke if the option is nil" do
        capture(:stdout){ G.start(["--skip-invoked"]) }.must_not =~ /invoke/
      end

      it "prints a message if invocation cannot be found" do
        content = capture(:stdout){ G.start(["--invoked", "unknown"]) }
        content.must =~ /error  unknown \[not found\]/
      end

      it "allows to invoke a class from the class binding by the given option" do
        content = capture(:stdout){ G.start(["--invoked", "e"]) }
        content.must =~ /invoke  e/
      end

      it "shows invocation information to the user" do
        @content.must =~ /invoke  defined/
      end

      it "uses padding on status generated by the invoked class" do
        @content.must =~ /finished    counting/
      end

      it "shows invoked options on help" do
        content = capture(:stdout){ G.help(Thor::Base.shell.new) }
        content.must =~ /defined options:/
        content.must =~ /\[--unused\]/
        content.must =~ /# This option has no use/
      end
    end

    describe "with boolean type" do
      before(:each) do
        @content = capture(:stdout){ H.start }
      end

      it "allows to invoke a class from the class binding by a default option" do
        @content.must =~ /1\n2\n3\n4\n5\n/
      end

      it "does not invoke if the option is false" do
        capture(:stdout){ H.start(["--no-defined"]) }.must_not =~ /invoke/
      end

      it "shows invocation information to the user" do
        @content.must =~ /invoke  defined/
      end

      it "uses padding on status generated by the invoked class" do
        @content.must =~ /finished    counting/
      end

      it "shows invoked options on help" do
        content = capture(:stdout){ H.help(Thor::Base.shell.new) }
        content.must =~ /defined options:/
        content.must =~ /\[--unused\]/
        content.must =~ /# This option has no use/
      end
    end
  end
end
