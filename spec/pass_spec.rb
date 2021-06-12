require "stringio"

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

RSpec.describe Pass do
  before do
    @pass = Pass.new
  end

  describe "出力される文字数" do
    it "文字数を指定できること" do
      expect(@pass.generate(5).size).to eq(5)
      expect(@pass.generate(12).size).to eq(12)
      expect(@pass.generate(30).size).to eq(30)
    end

    it "文字数を指定しない場合は#{Pass::DEFAULT_PASSWORD_LENGTH}文字であること" do
      expect(@pass.generate.size).to eq(Pass::DEFAULT_PASSWORD_LENGTH)
    end

    it "57文字以上のパスワードを生成できること" do
      expect(@pass.generate(57).size).to eq(57)
      expect(@pass.generate(200).size).to eq(200)
    end
  end

  describe "特定文字が含まれること含まれないこと" do
    it "見間違えやすい文字列が含まれないこと" do
      exclude_characters = %w[l o I O 1]
      50.times do
        expect((@pass.generate =~ /[#{exclude_characters.join}]/)).to be_nil
      end
    end
  end

  describe "例外の発生" do
    it "#{Pass::MIN_PASSWORD_LENGTH-1}以下の文字数を指定すると例外を発生すること" do
      expect { @pass.generate(Pass::MIN_PASSWORD_LENGTH-1) }.to raise_error(Pass::Error)
      expect { @pass.generate(0) }.to raise_error(Pass::Error)
      expect { @pass.generate(-10) }.to raise_error(Pass::Error)
    end

    it "不正な文字数を入力すると例外を発生すること" do
      expect { @pass.generate("abc") }.to raise_error(Pass::Error)
    end
  end

  describe "複数パスワードの生成" do
    it "指定した個数のパスワードを配列で返すこと" do
      expect(@pass.multi_generate(2).size).to eq(2)
    end
  end

  describe ".generate" do
    it "generates a password" do
      expect(Pass.generate.size).to eq(Pass::DEFAULT_PASSWORD_LENGTH)
    end

    it "generates a password with password length" do
      length = 30
      expect(Pass.generate(length).size).to eq(length)
    end
  end
end
