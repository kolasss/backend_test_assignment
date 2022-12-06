require 'rails_helper'

RSpec.describe Car, type: :model do
  describe '#label_comparable' do
    subject { car.label_comparable }

    let(:car) { described_class.new(label: label) }

    context 'if label is known' do
      let(:label) { 'perfect_match' }

      it 'returns integer instead of label' do
        expect(subject).to eq(0)
      end
    end

    context 'if label is unknown' do
      let(:label) { nil }

      it 'returns 9999' do
        expect(subject).to eq(9999)
      end
    end
  end

  describe '#rank_score_comparable' do
    subject { car.rank_score_comparable }

    let(:car) { described_class.new(rank_score: rank_score) }

    context 'if rank_score is known' do
      let(:rank_score) { 0.123 }

      it 'returns rank_score' do
        expect(subject).to eq(rank_score)
      end
    end

    context 'if rank_score is unknown' do
      let(:rank_score) { nil }

      it 'returns 0' do
        expect(subject).to eq(0)
      end
    end
  end
end
