require 'optparse'
require 'pass'
require 'pass/version'

class Pass
  class CLI
    class Error < StandardError; end

    def exec(argv)
      options = {}
      options[:length] = Pass::DEFAULT_PASSWORD_LENGTH

      opts = OptionParser.new

      opts.on('-c [NUMBER]', '(deprecated) specify password length') do |value|
        options[:length] = option_to_i(value)
      end

      opts.on('-l', '--length [NUMBER]', 'specify password length') do |value|
        options[:length] = option_to_i(value)
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
        num_passwords = if res_argv[0]
                          option_to_i(res_argv[0])
                        else
                          Pass::DEFAULT_NUM_PASSWORDS
                        end

        pass = Pass.new(**options)

        num_passwords.times do
          puts pass.generate
        end
      rescue Pass::Error, Pass::CLI::Error, OptionParser::ParseError => e
        abort "Error: #{e.message}"
      end

      exit 0
    end

    private

    def option_to_i(opt)
      Integer(opt)
    rescue ArgumentError => _e
      raise Error, "the option must be an integer: '#{opt}'"
    end

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
