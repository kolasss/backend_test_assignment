require 'rails_helper'

RSpec.describe Cars::Score do
  subject(:result) do
    VCR.use_cassette 'recomended_cars' do
      described_class.new.call(user_id)
    end
  end

  let(:user_id) { 1 }

  it 'returns array of scores data' do
    expect(result.class).to eq(Array)
    expect(result.size).to eq(9)
  end

  context 'when http error' do
    before do
      allow(HTTP).to receive(:get).and_raise HTTP::Error
    end

    it 'returns empty array' do
      expect(result).to eq([])
    end
  end

  describe 'caching' do
    let(:memory_store) { double }

    before do
      allow(Rails).to receive(:cache).and_return(memory_store)
      allow(memory_store).to receive(:fetch)
    end

    it 'uses Rails cache' do
      result
      expect(memory_store).to have_received(:fetch)
    end
  end
end
