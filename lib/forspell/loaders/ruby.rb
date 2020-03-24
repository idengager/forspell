# frozen_string_literal: true

require 'yard'
require 'yard/parser/ruby/ruby_parser'
require 'rdoc'
require_relative 'source'

module Forspell::Loaders
  class Ruby < Source
    MAX_COMMENT_LENGTH = 777
    ALLOWED_TYPES = %w(comment tstring_content)

    def initialize(file: nil, text: nil)
      super
      @markup = RDoc::Markup.new
      @formatter = RDoc::Markup::ToMarkdown.new
      @formatter.width = MAX_COMMENT_LENGTH
    end

    private

    def comments
      YARD::Parser::Ruby::RubyParser.new(@input, @file).parse
        .tokens.select { |type,| ALLOWED_TYPES.include? type.to_s }
        .reject { |_, text,| text.start_with?('#  ') }
    end

    def text(comment)
      @markup.convert(Forspell::Sanitizer.preprocess_ruby(comment[1]), @formatter)
    end

    def line(comment)
      comment.last.first
    end
  end
end
