# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Pass do
  it "文字数を指定できること" do
    Pass.generate(1).size.should be(1)
    Pass.generate(12).size.should be(12)
    Pass.generate(30).size.should be(30)
  end

  it "0以下の文字数を指定するとエラーを発生すること" do
    lambda{ Pass.generate(0) }.should raise_error
    lambda{ Pass.generate(-10) }.should raise_error
  end
end
