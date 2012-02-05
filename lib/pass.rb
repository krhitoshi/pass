
class Pass
  NUM_ITERATION = 100
  NUM_CHARACTERS = 12
  @list_carachters = ('a'..'z').to_a + ('A'..'Z').to_a + ('1'..'9').to_a
  @list_carachters.delete_if{|s| %w[l o I O 1].include? s }

  def Pass.generate(num = NUM_CHARACTERS)
    raise "Invalid Argument: number of characters should be more than 1." if num <= 2
    iteration = 0
    begin
      raise "Not Converged: #{NUM_ITERATION} times" if iteration > NUM_ITERATION
      pass = ''
      num.times{
        rand_num = rand(@list_carachters.size)
        pass += @list_carachters[rand_num]
      }
      iteration += 1
    end until Pass.valid?(pass)
    pass
  end

  def Pass.multi_generate(num_password, num_character = NUM_CHARACTERS)
    passwords = []
    num_password.times{
      passwords << Pass.generate(num_character)
    }
    passwords
  end

  def Pass.exec(argv)
    num_times = argv[0] || 1
    num_characters = argv[1] || NUM_CHARACTERS

    puts Pass.multi_generate(num_times.to_i, num_characters.to_i)
  end

  def Pass.valid?(pass)
    pass =~ /\d/ && pass =~ /[a-z]/ && pass =~ /[A-Z]/
  end
end
