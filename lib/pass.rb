require 'optparse'
require 'pass/version'

class Pass
  MIN_PASSWORD_LENGTH     = 5
  DEFAULT_NUM_PASSWORDS   = 1
  DEFAULT_PASSWORD_LENGTH = 20

  class Error < StandardError; end

  def initialize
    @list_chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('1'..'9').to_a - %w[l o I O 1]
  end

  def generate(num = DEFAULT_PASSWORD_LENGTH)
    if !integer?(num) || num < MIN_PASSWORD_LENGTH
      raise Pass::Error,
            "Invalid Argument: password length must be more than #{MIN_PASSWORD_LENGTH}."
    end

    rest_num = num
    pass = ""
    while rest_num > list_size
      pass += generate_password(list_size)
      rest_num -= list_size
    end
    pass += generate_password(rest_num)

    pass
  end

  def multi_generate(num_password, num_character = DEFAULT_PASSWORD_LENGTH)
    passwords = []

    num_password.times do
      passwords << generate(num_character)
    end

    passwords
  end

  def self.generate(num = DEFAULT_PASSWORD_LENGTH)
    new.generate(num)
  end

  def exec(argv)
    password_length = DEFAULT_PASSWORD_LENGTH

    opts = OptionParser.new

    opts.on('-c NUM', 'specify password length') do |value|
      password_length = value
    end

    opts.on_tail('-v', '--version', 'show version') do
      puts "pass #{Pass::VERSION}"
      exit 0
    end

    opts.banner = banner

    begin
      res_argv = opts.parse!(argv)
      num_passwords = res_argv[0] || DEFAULT_NUM_PASSWORDS

      puts multi_generate(num_passwords.to_i, password_length.to_i)
    rescue StandardError => e
      warn "Error: #{e.message}"
    end

    exit 0
  end

  private

  def banner
    <<~BANNER
      Usage: pass [options] [number of passwords]

      Description:
        The 'pass' command generates random passwords.

      Options:
    BANNER
  end

  def integer?(value)
    value.is_a?(Integer)
  end

  def list_size
    @list_chars.size
  end

  def generate_password(num)
    raise ArgumentError, "argument must be less than #{list_size}" if num > list_size

    @list_chars.sample(num).join
  end
end
