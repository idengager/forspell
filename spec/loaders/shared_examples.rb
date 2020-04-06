RSpec.shared_examples 'a comment loader' do
  it 'should contain all the words from comments' do
    comment_words = locations_with_words.flat_map do |location, words|
      words.map { |w| Forspell::Loaders::Word.new(path, location, w) }
    end
    is_expected.to contain_exactly(*comment_words)
  end
end

RSpec.shared_examples 'string literals loader' do
  it 'should contain all the words from string literals' do
    string_words = strings_array.flat_map do |location, words|
      words.map { |w| Forspell::Loaders::Word.new(path, location, w) }
    end
    is_expected.to contain_exactly(*string_words)
  end
end
