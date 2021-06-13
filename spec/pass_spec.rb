require "stringio"

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

RSpec.describe Pass do
  before do
    @pass = Pass.new
  end

  describe "#generate" do
    context "with password length argument" do
      before do
        @char_list_size = @pass.char_list.size
      end

      it "generates a password that has the specified length" do
        expect(@pass.generate(5).size).to eq(5)
        expect(@pass.generate(12).size).to eq(12)
        expect(@pass.generate(30).size).to eq(30)
      end

      it "generates a password longer than #{@char_list_size} characters" do
        expect(@pass.generate(@char_list_size + 1).size).to eq(@char_list_size + 1)
      end
    end

    context "with long enough password length argument" do
      it "generates a password not including ambiguous characters" do
        expect(@pass.generate(LONG_ENOUGH_LENGTH)).not_to match(AMBIGUOUS_CHARS_REGEXP)
      end
    end

    context "with no options" do
      it "generates a #{Pass::DEFAULT_PASSWORD_LENGTH}-character password" do
        expect(@pass.generate.size).to eq(Pass::DEFAULT_PASSWORD_LENGTH)
      end

      it "generates a password not including any symbols" do
        expect(@pass.generate(LONG_ENOUGH_LENGTH)).not_to match(SYMBOL_CHARS_REGEXP)
      end
    end

    context "with :symbols option" do
      it "generates a password including symbols" do
        pass = Pass.new(symbols: true)
        expect(pass.generate(LONG_ENOUGH_LENGTH)).to match(SYMBOL_CHARS_REGEXP)
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
