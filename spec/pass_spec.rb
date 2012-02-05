# -*- coding: utf-8 -*-
require "stringio"

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Pass do
  describe "出力される文字数" do
    it "文字数を指定できること" do
      Pass.generate(3).size.should be(3)
      Pass.generate(12).size.should be(12)
      Pass.generate(30).size.should be(30)
    end

    it "文字数を指定しない場合は12文字であること" do
      Pass.generate.size.should be(12)
    end
  end

  describe "特定文字が含まれること含まれないこと" do
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

    it "見間違えやすい文字列が含まれないこと" do
      exclude_characters = %w[l o I O 1]
      50.times do
        (Pass.generate =~ /[#{exclude_characters.join}]/).should be_false
      end
    end
  end

  describe "valid?" do
    it "validなパスワードでtrueを返すこと" do
      Pass.valid?("aT2").should be_true
      Pass.valid?("1bR").should be_true
      Pass.valid?("J0e").should be_true
    end

    it "invalidなパスワードでfalseを返すこと" do
      Pass.valid?("012").should be_false
      Pass.valid?("abc").should be_false
      Pass.valid?("ABC").should be_false
      Pass.valid?("0bc").should be_false
      Pass.valid?("0BC").should be_false
      Pass.valid?("AbC").should be_false
    end
  end

  describe "イテレーションの回数" do
    it "回数値を読み込めること" do
      Pass.num_iteration.should be(100)
    end

    it "回数値を変更できること" do
      Pass.num_iteration = 10
      Pass.num_iteration.should be(10)
    end

    it "0以下の回数値を入力すると例外を発生" do
      lambda{ Pass.num_iteration = 0 }.should raise_error
      lambda{ Pass.num_iteration = -10 }.should raise_error
    end
  end

  describe "エラーの発生" do
    describe "特定回数の生成試行数を超えるとエラーを発生すること" do
      before do
        Pass.num_iteration = 1
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
  end

  describe "複数パスワードの生成" do
    it "指定した個数のパスワードを配列で返すこと" do
      Pass.multi_generate(2).size.should be(2)
    end
  end

  describe "コマンド用メソッド" do
    it "指定したパスワードが返ってくること" do
      argv = %w[3 -c 16] # 16文字 3パスワード
      $stdout = StringIO.new
      Pass.exec(argv)
      passwords = $stdout.string.chomp.split("\n")
      passwords.size.should be(3)
      passwords.each do |password|
        password.size.should be(16)
      end
      $stdout = STDOUT
    end
  end
end
