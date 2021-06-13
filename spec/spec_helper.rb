$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "pass"
require 'pass/cli'

LONG_ENOUGH_LENGTH = 200

def chars_regexp(list)
  str = if list.is_a?(Array)
          list.join
        else
          list
        end

  /[#{Regexp.escape(str)}]/
end

SYMBOL_CHARS_REGEXP = chars_regexp(Pass::SYMBOL_CHARS - Pass::AMBIGUOUS_CHARS)
AMBIGUOUS_CHARS_REGEXP = chars_regexp(Pass::AMBIGUOUS_CHARS)
