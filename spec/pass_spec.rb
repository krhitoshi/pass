# -*- coding: utf-8 -*-
require "stringio"

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Pass do
  before do
    @pass = Pass.new
  end

  describe "出力される文字数" do
    it "文字数を指定できること" do
      @pass.generate(3).size.should be(3)
      @pass.generate(12).size.should be(12)
      @pass.generate(30).size.should be(30)
    end

    it "文字数を指定しない場合は12文字であること" do
      @pass.generate.size.should be(12)
    end
  end

  describe "特定文字が含まれること含まれないこと" do
    it "文字列に数字が1文字以上含まれること" do
      10.times do
        (@pass.generate(3) =~ /\d/).should be_true
      end
    end

    it "文字列に小文字が1文字以上含まれること" do
      10.times do
        (@pass.generate(3) =~ /[a-z]/).should be_true
      end
    end

    it "文字列に大文字が1文字以上含まれること" do
      10.times do
        (@pass.generate(3) =~ /[A-Z]/).should be_true
      end
    end

    it "見間違えやすい文字列が含まれないこと" do
      exclude_characters = %w[l o I O 1]
      50.times do
        (@pass.generate =~ /[#{exclude_characters.join}]/).should be_false
      end
    end
  end

  describe "valid?" do
    it "validなパスワードでtrueを返すこと" do
      @pass.valid?("aT2").should be_true
      @pass.valid?("1bR").should be_true
      @pass.valid?("J0e").should be_true
    end

    it "invalidなパスワードでfalseを返すこと" do
      @pass.valid?("012").should be_false
      @pass.valid?("abc").should be_false
      @pass.valid?("ABC").should be_false
      @pass.valid?("0bc").should be_false
      @pass.valid?("0BC").should be_false
      @pass.valid?("AbC").should be_false
    end
  end

  describe "イテレーションの回数" do
    it "回数値を読み込めること" do
      @pass.num_iteration.should be(100)
    end

    it "回数値を変更できること" do
      @pass.num_iteration = 10
      @pass.num_iteration.should be(10)
    end

    it "0以下の回数値を入力すると例外を発生" do
      lambda{ @pass.num_iteration = 0 }.should raise_error(Pass::Error)
      lambda{ @pass.num_iteration = -10 }.should raise_error(Pass::Error)
    end
  end

  describe "例外の発生" do
    describe "特定回数の生成試行数を超えると例外を発生すること" do
      before do
        @pass.num_iteration = 1
      end

      after do
        @pass.num_iteration = 100
      end

      it do
        lambda{
          10.times do
            @pass.generate(3)
          end
        }.should raise_error
      end
    end

    it "2以下の文字数を指定すると例外を発生すること" do
      lambda{ @pass.generate(2) }.should raise_error(Pass::Error)
      lambda{ @pass.generate(0) }.should raise_error(Pass::Error)
      lambda{ @pass.generate(-10) }.should raise_error(Pass::Error)
    end

    it "不正な回数値を入力すると例外を発生すること" do
      lambda{ @pass.num_iteration = "abc" }.should raise_error(Pass::Error)
    end

    it "不正な文字数を入力すると例外を発生すること" do
      lambda{ @pass.generate("abc") }.should raise_error(Pass::Error)
    end
  end

  describe "複数パスワードの生成" do
    it "指定した個数のパスワードを配列で返すこと" do
      @pass.multi_generate(2).size.should be(2)
    end
  end

  describe "コマンド用メソッド" do
    before do
      $stdout = StringIO.new
    end

    after do
      $stdout = STDOUT
    end

    it "オプション無しで1個のパスワードが返ってくること" do
      argv = [] # オプションなし
      lambda{ @pass.exec(argv) }.should raise_error(SystemExit)
      passwords = $stdout.string.chomp.split("\n")
      passwords.size.should be(1)
      passwords.first.size.should be(12)
    end

    it "パスワード数が指定できること" do
      argv = [20] # 20パスワード
      lambda{ @pass.exec(argv) }.should raise_error(SystemExit)
      passwords = $stdout.string.chomp.split("\n")
      passwords.size.should be(20)
      passwords.each do |password|
        password.size.should be(12)
      end
    end

    it "-cで文字数指定ができること" do
      argv = %w[3 -c 16] # 16文字 3パスワード
      lambda{ @pass.exec(argv) }.should raise_error(SystemExit)
      passwords = $stdout.string.chomp.split("\n")
      passwords.size.should be(3)
      passwords.each do |password|
        password.size.should be(16)
      end
    end

    it "指定順序が変わっても-cで文字数指定ができること" do
      argv = %w[-c 16 3] # 16文字 3パスワード
     lambda{ @pass.exec(argv) }.should raise_error(SystemExit)
      passwords = $stdout.string.chomp.split("\n")
      passwords.size.should be(3)
      passwords.each do |password|
        password.size.should be(16)
      end
    end

    it "-vでバージョン表示をするとSystemExitすること" do
      argv = %w[-v]
      lambda{ @pass.exec(argv) }.should raise_error(SystemExit)
    end

    it "-hでヘルプ表示をするとSystemExitすること" do
      argv = %w[-h]
      lambda{ @pass.exec(argv) }.should raise_error(SystemExit)
    end
  end
end
