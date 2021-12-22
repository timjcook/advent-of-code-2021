# frozen_string_literal: true

require_relative '../segment_searcher'

RSpec.describe SegmentSearcher do
  context 'with small input' do
    let(:input) do
      [
        'acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf'
      ]
    end

    describe '#num_identified_outputs' do
      subject do
        SegmentSearcher.num_identified_outputs input: input
      end

      it 'returns the expected number' do
        expect(subject).to eq 0
      end
    end

    describe '#sum_output_values' do
      subject do
        SegmentSearcher.sum_output_values input: input
      end

      it 'returns the expected number' do
        expect(subject).to eq 5353
      end
    end
  end

  context 'with large input' do
    let(:input) do
      [
        'be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe',
        'edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc',
        'fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg',
        'fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb',
        'aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea',
        'fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb',
        'dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe',
        'bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef',
        'egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb',
        'gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce'
      ]
    end

    describe '#num_identified_outputs' do
      subject do
        SegmentSearcher.num_identified_outputs input: input
      end

      it 'returns the expected number' do
        expect(subject).to eq 26
      end
    end

    describe '#sum_output_values' do
      subject do
        SegmentSearcher.sum_output_values input: input
      end

      it 'returns the expected number' do
        expect(subject).to eq 61_229
      end
    end
  end
end
