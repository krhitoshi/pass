require 'optparse'
require 'pass'
require 'pass/version'

class Pass
  class CLI
    def exec(argv)
      options = {}
      password_length = Pass::DEFAULT_PASSWORD_LENGTH

      opts = OptionParser.new

      opts.on('-c [NUMBER]', '(deprecated) specify password length') do |value|
        password_length = value
      end

      opts.on('-l', '--length [NUMBER]', 'specify password length') do |value|
        password_length = value
      end

      opts.on('-s', '--symbols', 'include symbols') do |value|
        options[:symbols] = value
      end

      opts.on('-e', '--exclude [CHARACTERS]', 'exclude characters') do |value|
        options[:exclude] = value
      end

      opts.on_tail('-v', '--version', 'show version') do
        puts "pass #{Pass::VERSION}"
        exit 0
      end

      opts.banner = banner

      begin
        res_argv = opts.parse!(argv)
        num_passwords = res_argv[0] || Pass::DEFAULT_NUM_PASSWORDS

        pass = Pass.new(**options)
        puts pass.multi_generate(num_passwords.to_i, password_length.to_i)
      rescue Pass::Error, OptionParser::ParseError => e
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
  end
end
