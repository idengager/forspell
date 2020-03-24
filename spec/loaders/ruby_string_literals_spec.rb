# frozen_string_literal: true

require_relative '../../lib/forspell/loaders/ruby'
require_relative 'shared_examples'

RSpec.describe Forspell::Loaders::Ruby do
  subject { described_class.new(file: path, text: nil).read }

  let(:strings_array) { {
                           4 => %w[registration mailer],
                           11 => %w[registration mailer change notification],
                           16 => %w[updated registration mailer change notification group],
                           20 => %w[data attributes],
                           21 => ['email'],
                           22 => ['name'],
                           23 => %w[locale fr],
                           29 => %w[Api import create],
                           32 => %w[uploads file],
                           33 => %w[returns success on file upload],
                           34 => %w[import csv],
                           42 => %w[regular comment],
                      } }

  let(:path) { File.join(__dir__, '..', 'fixtures', 'ruby_strings.rb') }

  it_behaves_like 'string literals loader'
end
