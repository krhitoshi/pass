require "stringio"

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

RSpec.describe Pass::CLI do
  before do
    @cli = Pass::CLI.new
    $stdout = StringIO.new
    $stderr = StringIO.new
  end

  after do
    $stdout = STDOUT
    $stderr = STDERR
  end

  context "with no options" do
    it "generates a #{Pass::DEFAULT_PASSWORD_LENGTH}-character password" do
      argv = [] # no options
      expect { @cli.exec(argv) }.to raise_error(SystemExit)
      passwords = $stdout.string.chomp.split("\n")
      expect(passwords.size).to eq(1)
      expect(passwords.first.size).to eq(Pass::DEFAULT_PASSWORD_LENGTH)
    end
  end

  context "with number of passwords" do
    it "generates passwords as many as you specified" do
      argv = [20] # 20 passwords
      expect { @cli.exec(argv) }.to raise_error(SystemExit)
      passwords = $stdout.string.chomp.split("\n")
      expect(passwords.size).to eq(20)
      passwords.each do |password|
        expect(password.size).to eq(Pass::DEFAULT_PASSWORD_LENGTH)
      end
    end
  end

  context "with -l option" do
    it "generates passwords as password length and numbers are specified #1" do
      argv = %w[3 -l 16] # length: 16 characters, num: 3
      expect { @cli.exec(argv) }.to raise_error(SystemExit)
      passwords = $stdout.string.chomp.split("\n")
      expect(passwords.size).to eq(3)
      passwords.each do |password|
        expect(password.size).to eq(16)
      end
    end

    it "generates passwords as password length and numbers are specified #2" do
      argv = %w[-l 16 3] # length: 16 characters, num: 3
      expect { @cli.exec(argv) }.to raise_error(SystemExit)
      passwords = $stdout.string.chomp.split("\n")
      expect(passwords.size).to eq(3)
      passwords.each do |password|
        expect(password.size).to eq(16)
      end
    end
  end

  context "with -v option" do
    it "raises SystemExit" do
      argv = %w[-v]
      expect { @cli.exec(argv) }.to raise_error(SystemExit)
    end
  end

  context "with -h option" do
    it "raises SystemExit" do
      argv = %w[-h]
      expect { @cli.exec(argv) }.to raise_error(SystemExit)
    end
  end

  context "with non-integer argument for the number of passwords" do
    it "displays an error" do
      argv = ['wrong_arg']
      expect { @cli.exec(argv) }.to raise_error(SystemExit)
      expect($stderr.string).to match(/the option must be an integer/)
    end
  end
end
