$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "pass"
require 'pass/cli'

LONG_ENOUGH_LENGTH = 200

symbols = (Pass::SYMBOL_CHARS - Pass::AMBIGUOUS_CHARS).join
SYMBOL_CHARS_REGEXP = /[#{Regexp.escape(symbols)}]/
