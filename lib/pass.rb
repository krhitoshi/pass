class Pass
  MIN_PASSWORD_LENGTH     = 5
  DEFAULT_NUM_PASSWORDS   = 1
  DEFAULT_PASSWORD_LENGTH = 20

  ALPHABETIC_CHARS = ('a'..'z').to_a + ('A'..'Z').to_a
  NUMERIC_CHARS    = ('1'..'9').to_a
  SYMBOL_CHARS     = ('!'..'/').to_a + (':'..'@').to_a + ('['..'`').to_a + ('{'..'~').to_a
  AMBIGUOUS_CHARS  = %w[l o I O 1 " ' ` |]

  class Error < StandardError; end

  def initialize(**options)
    @options = { length: DEFAULT_PASSWORD_LENGTH }
    @options.update(options)
  end

  def char_list
    list = ALPHABETIC_CHARS + NUMERIC_CHARS

    list += SYMBOL_CHARS if @options[:symbols]

    list -= exclude_char_list

    list
  end

  def exclude_char_list
    list = AMBIGUOUS_CHARS
    list += @options[:exclude].split(//).sort.uniq if @options[:exclude]
    list
  end

  def generate
    length = @options[:length]

    if length < MIN_PASSWORD_LENGTH
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

  def self.generate(num = DEFAULT_PASSWORD_LENGTH)
    new(length: num).generate
  end

  private

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
