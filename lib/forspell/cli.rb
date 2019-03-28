# frozen_string_literal: true

require 'slop'
require 'backports/2.5.0/hash/slice'
require_relative 'runner'
require_relative 'speller'
require_relative 'reporter'
require_relative 'file_list'

module Forspell
  class CLI
    ERROR_CODE = 2
    CONFIG_PATH = File.join(Dir.pwd, '.forspell')
    DEFAULT_CUSTOM_DICT = File.join(Dir.pwd, '.forspell.dict')

    FORMATS = %w[readable yaml json].freeze
    FORMAT_ERR = "must be one of the following: #{FORMATS.join(', ')}"
    DEFINITIONS = proc do |o|
      o.array '-e', '--exclude', 'Specify subdirectories to exclude'
      o.array '-d', '--dictionary-name', 'Use another hunspell dictionary', default: 'en_US'
      o.array '-c', '--custom-dictionaries', 'Add your custom dictionaries by specifying paths', default: []
      o.string '-f', '--format', 'Formats: dictionary, readable, JSON, YAML', default: 'readable'
      o.string '-l', '--logfile', 'Log to file'
      o.bool '-v', '--verbose', 'Verbose mode'
      o.on '--help' do
        puts o
        exit
      end
    end

    def initialize options
      @options = options
    end

    def call
      init_options
      create_files_list
      init_speller
      init_reporter
      run
    end

    private

    def create_files_list
      @files = FileList.new(paths: @opts.arguments, exclude_paths: @opts[:exclude])
    end

    def init_options
      @options += File.read(CONFIG_PATH).tr("\n", ' ').split(' ') if File.exist?(CONFIG_PATH)

      @opts = Slop.parse(@options, &DEFINITIONS)

      if @opts.arguments.empty?
        puts 'Usage: forspell paths to check [options]'
        puts 'Type --help for more info'
        exit(ERROR_CODE)
      end

      @opts[:format] = @opts[:format]&.downcase
    end

    def init_speller
      @opts[:custom_dictionaries].each do |path|
        next if File.exist?(path)

        puts "Custom dictionary not found: #{path}"
        exit(ERROR_CODE)
      end

      @opts[:custom_dictionaries] << DEFAULT_CUSTOM_DICT if File.exist?(DEFAULT_CUSTOM_DICT)

      @speller = Speller.new(@opts[:dictionary_name], *@opts[:custom_dictionaries])
    end

    def init_reporter
      @reporter = Reporter.new(**@opts.to_hash.slice(:logfile, :format, :verbose))
    end

    def run
      runner = Forspell::Runner.new(files: @files, speller: @speller, reporter: @reporter)
      runner.call
      exit @reporter.finalize
    rescue Forspell::FileList::PathLoadError => path
      @reporter.path_load_error path
      exit ERROR_CODE
    end
  end
end
