
class Pass
  NUM_ITERATION = 100
  @list = ('a'..'z').to_a + ('A'..'Z').to_a + ('1'..'9').to_a
  @list.delete_if{|s| ['l','o','I','O','1'].include? s }

  def Pass.generate(num = 12)
    raise "Invalid Argument: number of charactors should be more than 1." if num <= 2
    iteration = 0
    begin
      raise "Not Converged: #{NUM_ITERATION} times" if iteration > NUM_ITERATION
      pass = ''
      num.times{
        rand_num = rand(@list.size)
        pass += "#{@list[rand_num]}"
      }
      iteration += 1
    end until pass =~ /\d/ && pass =~ /[a-z]/ && pass =~ /[A-Z]/
    pass
  end
end
