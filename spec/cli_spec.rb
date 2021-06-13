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

  it "オプション無しで1個のパスワードが返ってくること" do
    argv = [] # オプションなし
    expect { @cli.exec(argv) }.to raise_error(SystemExit)
    passwords = $stdout.string.chomp.split("\n")
    expect(passwords.size).to eq(1)
    expect(passwords.first.size).to eq(Pass::DEFAULT_PASSWORD_LENGTH)
  end

  it "パスワード数が指定できること" do
    argv = [20] # 20パスワード
    expect { @cli.exec(argv) }.to raise_error(SystemExit)
    passwords = $stdout.string.chomp.split("\n")
    expect(passwords.size).to eq(20)
    passwords.each do |password|
      expect(password.size).to eq(Pass::DEFAULT_PASSWORD_LENGTH)
    end
  end

  it "-lで文字数指定ができること" do
    argv = %w[3 -l 16] # 16文字 3パスワード
    expect { @cli.exec(argv) }.to raise_error(SystemExit)
    passwords = $stdout.string.chomp.split("\n")
    expect(passwords.size).to eq(3)
    passwords.each do |password|
      expect(password.size).to eq(16)
    end
  end

  it "指定順序が変わっても-lで文字数指定ができること" do
    argv = %w[-l 16 3] # 16文字 3パスワード
    expect { @cli.exec(argv) }.to raise_error(SystemExit)
    passwords = $stdout.string.chomp.split("\n")
    expect(passwords.size).to eq(3)
    passwords.each do |password|
      expect(password.size).to eq(16)
    end
  end

  it "-vでバージョン表示をするとSystemExitすること" do
    argv = %w[-v]
    expect { @cli.exec(argv) }.to raise_error(SystemExit)
  end

  it "-hでヘルプ表示をするとSystemExitすること" do
    argv = %w[-h]
    expect { @cli.exec(argv) }.to raise_error(SystemExit)
  end

  context "with non-integer argument for the number of passwords" do
    it "displays an error" do
      argv = ['wrong_arg']
      expect { @cli.exec(argv) }.to raise_error(SystemExit)
      expect($stderr.string).to match(/the option must be an integer/)
    end
  end
end
