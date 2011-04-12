
class Pass
  @list = ('a'..'z').to_a + ('A'..'Z').to_a + ('1'..'9').to_a
  @list.delete_if{|s| ['l','o','I','O','1'].include? s }

  def Pass.generate(num)
    begin
      pass = ''
      num.times{
        rand_num = rand(@list.size)
        pass += "#{@list[rand_num]}"
      }
    end until pass =~ /\d/
    pass
  end
end
