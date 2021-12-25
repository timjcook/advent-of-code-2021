# frozen_string_literal: true

require_relative '../syntax_linter'

RSpec.describe SyntaxLinter do
  describe '#parse_line' do
    subject do
      SyntaxLinter.new
    end
  end
end

RSpec.describe SyntaxLine do
  subject do
    SyntaxLine.new line: line
  end

  describe '#parse_line' do
    context 'is incomplete' do
      context 'with line one' do
        let(:line) { '([]' }

        it 'returns the expected line' do
          expect(subject.complete?).to eq false
          expect(subject.autocomplete_score).to eq 1
        end
      end

      context 'with line two' do
        let(:line) { '{()()(' }

        it 'returns the expected line' do
          expect(subject.complete?).to eq false
          expect(subject.autocomplete_score).to eq 8
        end
      end

      context 'with line two' do
        let(:line) { '{([<<' }

        it 'returns the expected line' do
          expect(subject.complete?).to eq false
          expect(subject.autocomplete_score).to eq 3058
        end
      end
    end

    context 'is valid' do
      context 'with line one' do
        let(:line) { '([])' }

        it 'returns the expected line' do
          expect(subject.valid?).to eq true
          expect(subject.chunks).to eq 2
        end
      end

      context 'with line two' do
        let(:line) { '{()()()}' }

        it 'returns the expected line' do
          expect(subject.valid?).to eq true
          expect(subject.chunks).to eq 4
        end
      end

      context 'with line three' do
        let(:line) { '<([{}])>' }

        it 'returns the expected line' do
          expect(subject.valid?).to eq true
          expect(subject.chunks).to eq 4
        end
      end

      context 'with line four' do
        let(:line) { '[<>({}){}[([])<>]]' }

        it 'returns the expected line' do
          expect(subject.valid?).to eq true
          expect(subject.chunks).to eq 9
        end
      end

      context 'with line five' do
        let(:line) { '(((((((((())))))))))' }

        it 'returns the expected line' do
          expect(subject.valid?).to eq true
          expect(subject.chunks).to eq 10
        end
      end
    end

    context 'is invalid' do
      context 'with line one' do
        let(:line) { '(]' }

        it 'returns the expected line' do
          expect(subject.valid?).to eq false
          expect(subject.chunks).to eq nil
          expect(subject.illegal_close_score).to eq 57
        end
      end

      context 'with line two' do
        let(:line) { '{()()()>' }

        it 'returns the expected line' do
          expect(subject.valid?).to eq false
          expect(subject.chunks).to eq nil
          expect(subject.illegal_close_score).to eq 25_137
        end
      end

      context 'with line three' do
        let(:line) { '(((()))}' }

        it 'returns the expected line' do
          expect(subject.valid?).to eq false
          expect(subject.chunks).to eq nil
          expect(subject.illegal_close_score).to eq 1197
        end
      end

      context 'with line four' do
        let(:line) { '<([]){()}[{}])' }

        it 'returns the expected line' do
          expect(subject.valid?).to eq false
          expect(subject.chunks).to eq nil
          expect(subject.illegal_close_score).to eq 3
        end
      end
    end
  end
end
