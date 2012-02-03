# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Pass do
  it "文字数を指定できること" do
    Pass.generate(3).size.should be(3)
    Pass.generate(12).size.should be(12)
    Pass.generate(30).size.should be(30)
  end

  it "文字数を指定しない場合は12文字であること" do
    Pass.generate.size.should be(12)
  end

  it "文字列に数字が1文字以上含まれること" do
    10.times do
      (Pass.generate(3) =~ /\d/).should be_true
    end
  end

  it "文字列に小文字が1文字以上含まれること" do
    10.times do
      (Pass.generate(3) =~ /[a-z]/).should be_true
    end
  end

  it "文字列に大文字が1文字以上含まれること" do
    10.times do
      (Pass.generate(3) =~ /[A-Z]/).should be_true
    end
  end

  describe "特定回数の生成試行数を超えるとエラーを発生すること" do
    before do
      Pass::NUM_ITERATION = 1
    end
    it do
      lambda{
        10.times do
          Pass.generate(3)
        end
      }.should raise_error
    end
  end

  it "2以下の文字数を指定するとエラーを発生すること" do
    lambda{ Pass.generate(2) }.should raise_error
    lambda{ Pass.generate(0) }.should raise_error
    lambda{ Pass.generate(-10) }.should raise_error
  end

  it "見間違えやすい文字列が含まれないこと" do
    exclude_characters = %w[l o I O 1]
    50.times do
      (Pass.generate =~ /[#{exclude_characters.join('')}]/).should be_false
    end
  end
end
