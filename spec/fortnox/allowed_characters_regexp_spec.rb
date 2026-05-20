# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Fortnox::ALLOWED_CHARACTERS_REGEXP do
  subject(:regexp) { described_class }

  describe 'accepted strings' do
    [
      ['empty string', ''],
      ['plain ASCII', 'Hello world'],
      ['Swedish letters', 'Räksmörgås på Öland'],
      ['common punctuation', 'foo, bar; baz: qux.'],
      ['currency symbols', '€100 £50 $25 ¢5 ¥¤'],
      ['symbols allowed by Fortnox', '©™®°§½²³'],
      ['arithmetic and brackets', '(a + b) * c = d / e - f'],
      ['quotes and marks', 'It`s ´fine´ ’really’'],
      ['hash, percent, ampersand', '#42 100% A&B'],
      ['at-sign, underscore, bang, question', 'foo_bar@example !?'],
      ['combining diaeresis', 'ü'],
      ['combining ring above', 'å'],
      ['non-breaking space', 'a b'],
      ['newlines and carriage returns', "line1\nline2\r\nline3"],
      ['en dash', 'pages 1–10'],
      ['backslash', 'C:\\path\\to\\file']
    ].each do |label, value|
      it "matches #{label}" do
        expect(regexp.match?(value)).to be true
      end
    end
  end

  describe 'rejected strings' do
    [
      ['emoji', 'rocket 🚀'],
      ['NUL byte', "foo\0bar"],
      ['tab character', "foo\tbar"],
      ['bell character', "foo\abar"],
      ['vertical bar', 'foo|bar'],
      ['tilde', 'foo~bar'],
      ['curly braces', 'foo{bar}'],
      ['square brackets', 'foo[bar]'],
      ['em dash (only en dash is allowed)', 'foo — bar']
    ].each do |label, value|
      it "rejects #{label}" do
        expect(regexp.match?(value)).to be false
      end
    end
  end
end
