require 'optparse'
require 'pass/version'

class Pass
  MIN_PASSWORD_LENGTH     = 5
  DEFAULT_NUM_PASSWORDS   = 1
  DEFAULT_PASSWORD_LENGTH = 20

  ALPHABETIC_CHARS = ('a'..'z').to_a + ('A'..'Z').to_a
  NUMERIC_CHARS    = ('1'..'9').to_a
  SYMBOL_CHARS     = ('!'..'/').to_a + (':'..'@').to_a + ('['..'`').to_a + ('{'..'~').to_a
  AMBIGUOUS_CHARS  = %w[l o I O 1 " ' ` |]

  class Error < StandardError; end

  def initialize
    @options = {}
  end

  def char_list
    if @options[:symbols]
      ALPHABETIC_CHARS + NUMERIC_CHARS + SYMBOL_CHARS - AMBIGUOUS_CHARS
    else
      ALPHABETIC_CHARS + NUMERIC_CHARS - AMBIGUOUS_CHARS
    end
  end

  def generate(length = DEFAULT_PASSWORD_LENGTH)
    if !integer?(length) || length < MIN_PASSWORD_LENGTH
      raise Pass::Error,
            "Invalid Argument: password length must be more than #{MIN_PASSWORD_LENGTH}."
    end

    rest_length = length
    result = ""
    # append append password string until 'result' reaches the 'length'
    while rest_length > char_list_size
      result += generate_password_base(char_list_size)
      rest_length -= char_list_size
    end
    result += generate_password_base(rest_length)

    result
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

    opts.on('-s', 'include symbols') do
      @options[:symbols] = true
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

  def char_list_size
    char_list.size
  end

  # generate a password that is long less than 'char_list_size'
  def generate_password_base(length)
    if length > char_list_size
      raise ArgumentError, "argument must be less than #{char_list_size}"
    end

    char_list.sample(length).join
  end
end
