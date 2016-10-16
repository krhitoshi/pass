# -*- coding: utf-8 -*-
require "stringio"

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Pass do
  before do
    @pass = Pass.new
  end

  describe "出力される文字数" do
    it "文字数を指定できること" do
      expect(@pass.generate(3).size).to eq(3)
      expect(@pass.generate(12).size).to eq(12)
      expect(@pass.generate(30).size).to eq(30)
    end

    it "文字数を指定しない場合は12文字であること" do
      expect(@pass.generate.size).to eq(12)
    end
  end

  describe "特定文字が含まれること含まれないこと" do
    it "文字列に数字が1文字以上含まれること" do
      10.times do
        expect((@pass.generate(3) =~ /\d/)).to_not be_nil
      end
    end

    it "文字列に小文字が1文字以上含まれること" do
      10.times do
        expect((@pass.generate(3) =~ /[a-z]/)).to_not be_nil
      end
    end

    it "文字列に大文字が1文字以上含まれること" do
      10.times do
        expect((@pass.generate(3) =~ /[A-Z]/)).to_not be_nil
      end
    end

    it "見間違えやすい文字列が含まれないこと" do
      exclude_characters = %w[l o I O 1]
      50.times do
        expect((@pass.generate =~ /[#{exclude_characters.join}]/)).to be_nil
      end
    end
  end

  describe "valid?" do
    it "validなパスワードでtrueを返すこと" do
      expect(@pass.valid?("aT2")).to eq(true)
      expect(@pass.valid?("1bR")).to eq(true)
      expect(@pass.valid?("J0e")).to eq(true)
    end

    it "invalidなパスワードでfalseを返すこと" do
      expect(@pass.valid?("012")).to eq(false)
      expect(@pass.valid?("abc")).to eq(false)
      expect(@pass.valid?("ABC")).to eq(false)
      expect(@pass.valid?("0bc")).to eq(false)
      expect(@pass.valid?("0BC")).to eq(false)
      expect(@pass.valid?("AbC")).to eq(false)
    end
  end

  describe "イテレーションの回数" do
    it "回数値を読み込めること" do
      expect(@pass.num_iteration).to eq(100)
    end

    it "回数値を変更できること" do
      @pass.num_iteration = 10
      expect(@pass.num_iteration).to eq(10)
    end

    it "0以下の回数値を入力すると例外を発生" do
      expect{ @pass.num_iteration = 0 }.to raise_error(Pass::Error)
      expect{ @pass.num_iteration = -10 }.to raise_error(Pass::Error)
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
        expect{
          10.times do
            @pass.generate(3)
          end
        }.to raise_error(Pass::Error)
      end
    end

    it "2以下の文字数を指定すると例外を発生すること" do
      expect{ @pass.generate(2) }.to raise_error(Pass::Error)
      expect{ @pass.generate(0) }.to raise_error(Pass::Error)
      expect{ @pass.generate(-10) }.to raise_error(Pass::Error)
    end

    it "不正な回数値を入力すると例外を発生すること" do
      expect{ @pass.num_iteration = "abc" }.to raise_error(Pass::Error)
    end

    it "不正な文字数を入力すると例外を発生すること" do
      expect{ @pass.generate("abc") }.to raise_error(Pass::Error)
    end
  end

  describe "複数パスワードの生成" do
    it "指定した個数のパスワードを配列で返すこと" do
      expect(@pass.multi_generate(2).size).to eq(2)
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
      expect{ @pass.exec(argv) }.to raise_error(SystemExit)
      passwords = $stdout.string.chomp.split("\n")
      expect(passwords.size).to eq(1)
      expect(passwords.first.size).to eq(12)
    end

    it "パスワード数が指定できること" do
      argv = [20] # 20パスワード
      expect{ @pass.exec(argv) }.to raise_error(SystemExit)
      passwords = $stdout.string.chomp.split("\n")
      expect(passwords.size).to eq(20)
      passwords.each do |password|
        expect(password.size).to eq(12)
      end
    end

    it "-cで文字数指定ができること" do
      argv = %w[3 -c 16] # 16文字 3パスワード
      expect{ @pass.exec(argv) }.to raise_error(SystemExit)
      passwords = $stdout.string.chomp.split("\n")
      expect(passwords.size).to eq(3)
      passwords.each do |password|
        expect(password.size).to eq(16)
      end
    end

    it "指定順序が変わっても-cで文字数指定ができること" do
      argv = %w[-c 16 3] # 16文字 3パスワード
     expect{ @pass.exec(argv) }.to raise_error(SystemExit)
      passwords = $stdout.string.chomp.split("\n")
      expect(passwords.size).to eq(3)
      passwords.each do |password|
        expect(password.size).to eq(16)
      end
    end

    it "-vでバージョン表示をするとSystemExitすること" do
      argv = %w[-v]
      expect{ @pass.exec(argv) }.to raise_error(SystemExit)
    end

    it "-hでヘルプ表示をするとSystemExitすること" do
      argv = %w[-h]
      expect{ @pass.exec(argv) }.to raise_error(SystemExit)
    end
  end
end
