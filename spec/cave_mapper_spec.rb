# frozen_string_literal: true

require_relative '../cave_mapper'

RSpec.describe CaveMapper do
  let(:input_1) do
    [
      'start-A',
      'start-b',
      'A-c',
      'A-b',
      'b-d',
      'A-end',
      'b-end'
    ]
  end
  let(:input_2) do
    [
      'dc-end',
      'HN-start',
      'start-kj',
      'dc-start',
      'dc-HN',
      'LN-dc',
      'HN-end',
      'kj-sa',
      'kj-HN',
      'kj-dc'
    ]
  end
  let(:input_3) do
    [
      'fs-end',
      'he-DX',
      'fs-he',
      'start-DX',
      'pj-DX',
      'end-zg',
      'zg-sl',
      'zg-pj',
      'pj-he',
      'RW-he',
      'fs-DX',
      'pj-RW',
      'zg-RW',
      'start-pj',
      'he-WI',
      'zg-he',
      'pj-fs',
      'start-RW'
    ]
  end

  describe '#num_paths' do
    subject do
      CaveMapper.num_paths(input: input, allow_small_cave_return: allow_small_cave_return)
    end

    context 'with 0 small returns' do
      let(:allow_small_cave_return) { false }

      context 'with input 1' do
        let(:input) { input_1 }

        it 'returns the expected number' do
          expect(subject).to eq 10
        end
      end

      context 'with input 2' do
        let(:input) { input_2 }

        it 'returns the expected number' do
          expect(subject).to eq 19
        end
      end

      context 'with input 3' do
        let(:input) { input_3 }

        it 'returns the expected number' do
          expect(subject).to eq 226
        end
      end
    end

    context 'with 1 small return' do
      let(:allow_small_cave_return) { true }

      context 'with input 1' do
        let(:input) { input_1 }

        it 'returns the expected number' do
          expect(subject).to eq 36
        end
      end

      context 'with input 2' do
        let(:input) { input_2 }

        it 'returns the expected number' do
          expect(subject).to eq 103
        end
      end

      context 'with input 3' do
        let(:input) { input_3 }

        it 'returns the expected number' do
          expect(subject).to eq 3509
        end
      end
    end
  end

  describe '#paths' do
    subject do
      mapper = CaveMapper.new(input: input, allow_small_cave_return: allow_small_cave_return)
      mapper.paths.map { |path| path.map(&:name).join(',') }
    end

    context 'with 0 small returns' do
      let(:allow_small_cave_return) { false }
      context 'with input 1' do
        let(:input) { input_1 }

        it 'returns the expected set of systems' do
          expect(subject).to contain_exactly(
            'start,A,b,A,c,A,end',
            'start,A,b,A,end',
            'start,A,b,end',
            'start,A,c,A,b,A,end',
            'start,A,c,A,b,end',
            'start,A,c,A,end',
            'start,A,end',
            'start,b,A,c,A,end',
            'start,b,A,end',
            'start,b,end'
          )
        end
      end

      context 'with input 2' do
        let(:input) { input_2 }

        it 'returns the expected set of systems' do
          expect(subject).to contain_exactly(
            'start,HN,dc,HN,end',
            'start,HN,dc,HN,kj,HN,end',
            'start,HN,dc,end',
            'start,HN,dc,kj,HN,end',
            'start,HN,end',
            'start,HN,kj,HN,dc,HN,end',
            'start,HN,kj,HN,dc,end',
            'start,HN,kj,HN,end',
            'start,HN,kj,dc,HN,end',
            'start,HN,kj,dc,end',
            'start,dc,HN,end',
            'start,dc,HN,kj,HN,end',
            'start,dc,end',
            'start,dc,kj,HN,end',
            'start,kj,HN,dc,HN,end',
            'start,kj,HN,dc,end',
            'start,kj,HN,end',
            'start,kj,dc,HN,end',
            'start,kj,dc,end'
          )
        end
      end
    end

    context 'with 1 small return' do
      let(:allow_small_cave_return) { true }

      context 'with input 1' do
        let(:input) { input_1 }

        it 'returns the expected set of systems' do
          expect(subject).to contain_exactly(
            'start,A,b,A,b,A,c,A,end',
            'start,A,b,A,b,A,end',
            'start,A,b,A,b,end',
            'start,A,b,A,c,A,b,A,end',
            'start,A,b,A,c,A,b,end',
            'start,A,b,A,c,A,c,A,end',
            'start,A,b,A,c,A,end',
            'start,A,b,A,end',
            'start,A,b,d,b,A,c,A,end',
            'start,A,b,d,b,A,end',
            'start,A,b,d,b,end',
            'start,A,b,end',
            'start,A,c,A,b,A,b,A,end',
            'start,A,c,A,b,A,b,end',
            'start,A,c,A,b,A,c,A,end',
            'start,A,c,A,b,A,end',
            'start,A,c,A,b,d,b,A,end',
            'start,A,c,A,b,d,b,end',
            'start,A,c,A,b,end',
            'start,A,c,A,c,A,b,A,end',
            'start,A,c,A,c,A,b,end',
            'start,A,c,A,c,A,end',
            'start,A,c,A,end',
            'start,A,end',
            'start,b,A,b,A,c,A,end',
            'start,b,A,b,A,end',
            'start,b,A,b,end',
            'start,b,A,c,A,b,A,end',
            'start,b,A,c,A,b,end',
            'start,b,A,c,A,c,A,end',
            'start,b,A,c,A,end',
            'start,b,A,end',
            'start,b,d,b,A,c,A,end',
            'start,b,d,b,A,end',
            'start,b,d,b,end',
            'start,b,end'
          )
        end
      end
    end
  end
end
