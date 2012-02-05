require 'optparse'

class Pass
  NUM_CHARACTERS = 12
  def initialize
    @list_carachters = ('a'..'z').to_a + ('A'..'Z').to_a + ('1'..'9').to_a
    @list_carachters.delete_if{|s| %w[l o I O 1].include? s }
    @num_iteration = 100
  end

  def generate(num = NUM_CHARACTERS)
    raise "Invalid Argument: number of characters should be more than 1." if num <= 2
    iteration = 0
    begin
      raise "Not Converged: #{@num_iteration} times" if iteration > @num_iteration
      pass = ''
      num.times{
        rand_num = rand(@list_carachters.size)
        pass += @list_carachters[rand_num]
      }
      iteration += 1
    end until valid?(pass)
    pass
  end

  def Pass.generate(num = NUM_CHARACTERS)
    pass = Pass.new
    pass.generate(num)
  end

  def valid?(pass)
    pass =~ /\d/ && pass =~ /[a-z]/ && pass =~ /[A-Z]/
  end

  def multi_generate(num_password, num_character = NUM_CHARACTERS)
    passwords = []
    num_password.times{
      passwords << generate(num_character)
    }
    passwords
  end

  def Pass.multi_generate(num_password, num_character = NUM_CHARACTERS)
    Pass.new.multi_generate(num_password, num_character)
  end

  def Pass.exec(argv)
    num_characters = NUM_CHARACTERS
    opts = OptionParser.new
    opts.on('-c NUM', 'Number of Password Characters') do |value|
      num_characters = value
    end
    opts.on_tail('-v', '--version', 'Show version') do
      number = File.read(File.dirname(__FILE__) + '/../VERSION')
      puts "#{self.name} #{number.chomp}"
      exit
    end
    opts.banner = <<END
Usage: pass [options] [number of passwords]

Description:
  Generates random passwords.

Options:
END
    res_argv = opts.parse!(argv)
    num_times = res_argv[0] || 1
    puts Pass.multi_generate(num_times.to_i, num_characters.to_i)
  end

  def num_iteration
    @num_iteration
  end

  def num_iteration=(value)
    raise "Invalid Argument: num_iteration #{value}" if value <= 0
    @num_iteration = value
  end
end
