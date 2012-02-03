# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Pass do
  it "文字数を指定できること" do
    Pass.generate(12).size.should be(12)
  end
end
