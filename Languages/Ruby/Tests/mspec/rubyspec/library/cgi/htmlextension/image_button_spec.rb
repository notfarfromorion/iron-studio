require File.dirname(__FILE__) + '/../../../spec_helper'
require 'cgi'
require File.dirname(__FILE__) + "/fixtures/common"

describe "CGI::HtmlExtension#image_button" do
  before(:each) do
    @html = CGISpecs::HtmlExtension.new
  end

  describe "when passed no arguments" do
    it "returns an image-'input'-element without a source image" do
      output = @html.image_button
      output.should equal_element("INPUT", {"SRC" => "", "TYPE" => "image"}, "", :not_closed => true)
    end
    
    it "ignores a passed block" do
      output = @html.image_button { "test" }
      output.should equal_element("INPUT", {"SRC" => "", "TYPE" => "image"}, "", :not_closed => true)
    end
  end

  describe "when passed src" do
    it "returns an image-'input'-element with the passed src" do
      output = @html.image_button("/path/to/image.png")
      output.should equal_element("INPUT", {"SRC" => "/path/to/image.png", "TYPE" => "image"}, "", :not_closed => true)
    end

    it "ignores a passed block" do
      output = @html.image_button("/path/to/image.png") { "test" }
      output.should equal_element("INPUT", {"SRC" => "/path/to/image.png", "TYPE" => "image"}, "", :not_closed => true)
    end
  end

  describe "when passed src, name" do
    it "returns an image-'input'-element with the passed src and name" do
      output = @html.image_button("/path/to/image.png", "test")
      output.should equal_element("INPUT", {"SRC" => "/path/to/image.png", "TYPE" => "image", "NAME" => "test"}, "", :not_closed => true)
    end
    
    it "ignores a passed block" do
      output = @html.image_button("/path/to/image.png", "test") { "test" }
      output.should equal_element("INPUT", {"SRC" => "/path/to/image.png", "TYPE" => "image", "NAME" => "test"}, "", :not_closed => true)
    end
  end

  describe "when passed src, name, alt" do
    it "returns an image-'input'-element with the passed src, name and alt" do
      output = @html.image_button("/path/to/image.png", "test", "alternative")
      output.should equal_element("INPUT", {"SRC" => "/path/to/image.png", "TYPE" => "image", "NAME" => "test", "ALT" => "alternative"}, "", :not_closed => true)
    end
    
    it "ignores a passed block" do
      output = @html.image_button("/path/to/image.png", "test", "alternative") { "test" }
      output.should equal_element("INPUT", {"SRC" => "/path/to/image.png", "TYPE" => "image", "NAME" => "test", "ALT" => "alternative"}, "", :not_closed => true)
    end
  end

  describe "when passed Hash" do
    it "returns a image-'input'-element using the passed Hash for attributes" do
      output = @html.image_button("NAME" => "test", "VALUE" => "test-value")
      output.should equal_element("INPUT", {"SRC" => "", "TYPE" => "image", "NAME" => "test", "VALUE" => "test-value"}, "", :not_closed => true)
    end

    it "ignores a passed block" do
      output = @html.image_button("NAME" => "test", "VALUE" => "test-value") { "test" }
      output.should equal_element("INPUT", {"SRC" => "", "TYPE" => "image", "NAME" => "test", "VALUE" => "test-value"}, "", :not_closed => true)
    end
  end
end