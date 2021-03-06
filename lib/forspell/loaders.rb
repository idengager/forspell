# frozen_string_literal: true

require_relative 'loaders/markdown'
require_relative 'loaders/ruby'
require_relative 'loaders/c'

module Forspell
  module Loaders
    class ParsingError < StandardError; end
    
    EXT_TO_PARSER_CLASS = {
      '.rb' => Loaders::Ruby,
      '.c' => Loaders::C,
      '.cpp' => Loaders::C,
      '.cxx' => Loaders::C,
      '.md' => Loaders::Markdown
    }.freeze

    def self.for(path)
      EXT_TO_PARSER_CLASS[File.extname(path)].new(file: path)
    end
  end
end
