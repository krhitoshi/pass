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
        [5, 12, 30].each do |num|
          pass = Pass.new(length: num)
          expect(pass.generate.size).to eq(num)
        end
      end

      it "generates a password longer than #{@char_list_size} characters" do
        num = @char_list_size + 1
        pass = Pass.new(length: num)
        expect(pass.generate.size).to eq(num)
      end
    end

    context "with long enough password length argument" do
      it "generates a password not including ambiguous characters" do
        pass = Pass.new(length: LONG_ENOUGH_LENGTH)
        result = pass.generate
        expect(result).not_to match(AMBIGUOUS_CHARS_REGEXP)
        expect(result.size).to eq(LONG_ENOUGH_LENGTH)
      end
    end

    context "with no options" do
      it "generates a #{Pass::DEFAULT_PASSWORD_LENGTH}-character password" do
        expect(@pass.generate.size).to eq(Pass::DEFAULT_PASSWORD_LENGTH)
      end

      it "generates a password not including any symbols" do
        pass = Pass.new(length: LONG_ENOUGH_LENGTH)
        result = pass.generate
        expect(result).not_to match(SYMBOL_CHARS_REGEXP)
        expect(result.size).to eq(LONG_ENOUGH_LENGTH)
      end
    end

    context "with :length option" do
      it "generates a password that has the specified length" do
        pass = Pass.new(length: 30)
        expect(pass.generate.size).to eq(30)
      end
    end

    context "with :symbols option" do
      it "generates a password including symbols" do
        pass = Pass.new(symbols: true, length: LONG_ENOUGH_LENGTH)
        expect(pass.generate).to match(SYMBOL_CHARS_REGEXP)
      end
    end

    context "with :exclude option" do
      it "generates a password not including specified characters" do
        list = 'ABCDEFGHabcdefgh'
        pass = Pass.new(exclude: 'ABCDEFGHabcdefgh', length: LONG_ENOUGH_LENGTH)
        result = pass.generate
        expect(result).not_to match(chars_regexp(list))
        expect(result.size).to eq(LONG_ENOUGH_LENGTH)
      end
    end
  end

  describe "例外の発生" do
    it "#{Pass::MIN_PASSWORD_LENGTH-1}以下の文字数を指定すると例外を発生すること" do
      [(Pass::MIN_PASSWORD_LENGTH-1) , 0, -10].each do |num|
        pass = Pass.new(length: num)
        expect { pass.generate }.to raise_error(Pass::Error)
      end
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
