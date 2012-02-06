require 'optparse'

class Pass
  MIN_NUM_CHARACTERS = 3
  NUM_CHARACTERS = 12

  class Error < StandardError; end

  def initialize
    @list_carachters = ('a'..'z').to_a + ('A'..'Z').to_a + ('1'..'9').to_a
    @list_carachters.delete_if{|s| %w[l o I O 1].include? s }
    @num_iteration = 100
  end

  def generate(num = NUM_CHARACTERS)
    if num < MIN_NUM_CHARACTERS
      raise Pass::Error, "Invalid Argument: number of characters should be more than #{MIN_NUM_CHARACTERS}."
    end

    @num_iteration.times do
      pass = ''
      num.times do
        pass += @list_carachters.sample
      end
      return pass if valid?(pass)
    end
    raise "Not Converged: #{@num_iteration} times"
  end

  def valid?(pass)
    pass =~ /\d/ && pass =~ /[a-z]/ && pass =~ /[A-Z]/
  end

  def multi_generate(num_password, num_character = NUM_CHARACTERS)
    passwords = []
    num_password.times do
      passwords << generate(num_character)
    end
    passwords
  end

  def Pass.generate(num = NUM_CHARACTERS)
    Pass.new.generate(num)
  end

  def exec(argv)
    num_characters = NUM_CHARACTERS
    opts = OptionParser.new
    opts.on('-c NUM', 'Number of Password Characters') do |value|
      num_characters = value
    end
    opts.on_tail('-v', '--version', 'Show version') do
      puts "#{self.class.name} #{version}"
      exit 0
    end
    opts.banner = <<END
Usage: pass [options] [number of passwords]

Description:
  Generates random passwords.

Options:
END
    begin
      res_argv = opts.parse!(argv)
      num_times = res_argv[0] || 1
      puts multi_generate(num_times.to_i, num_characters.to_i)
    rescue SystemExit
    rescue Exception => e
      $stderr.puts "Error: #{e.message}"
      exit 1
    end
    exit 0
  end

  def num_iteration
    @num_iteration
  end

  def num_iteration=(value)
    raise(Error, "Invalid Argument: num_iteration #{value}") if !value.kind_of?(Integer) || value <= 0
    @num_iteration = value
  end

  def version
    number = File.read(File.dirname(__FILE__) + '/../VERSION')
    number.chomp
  end
end
