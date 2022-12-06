require 'rails_helper'

RSpec.describe Cars::Recommend do
  subject(:result) do
    described_class.new.call(**params)
  end

  let(:user) { create(:user) }
  let(:toyota) { create(:brand) }
  let!(:car1) { create(:car, price: 40_687, brand: toyota) }
  let!(:car2) { create(:car, price: 16_783) }
  let(:scores_data) do
    [
      { car_id: car1.id, rank_score: 0.945 },
      { car_id: car2.id, rank_score: 0.4552 }
    ]
  end
  let(:score_double) { double }

  let(:params) { { user_id: user.id } }

  before do
    allow(Cars::Score).to receive(:new).and_return(score_double)
    allow(score_double).to receive(:call).and_return(scores_data)
  end

  it 'returns array of cars' do
    expect(result.class).to eq(Array)
    expect(result.size).to eq(2)
  end

  it 'fills ranks_scores' do
    expect(result[0].rank_score).to eq(0.945)
    expect(result[1].rank_score).to eq(0.4552)
  end

  it 'calls score service' do
    result
    expect(score_double).to have_received(:call).with(user.id)
  end

  context 'with price_min' do
    let(:params) { { user_id: user.id, price_min: 20_000 } }

    it 'filters out 1 car' do
      expect(result.size).to eq(1)
      expect(result[0].model).to eq(car1.model)
    end
  end

  context 'with price_max' do
    let(:params) { { user_id: user.id, price_max: 20_000 } }

    it 'filters out 1 car' do
      expect(result.size).to eq(1)
      expect(result[0].model).to eq(car2.model)
    end
  end

  context 'with query' do
    let(:toyota) { create(:brand, name: 'Toyota') }
    let(:params) { { user_id: user.id, query: 'toy' } }

    it 'filters out 1 car' do
      expect(result.size).to eq(1)
      expect(result[0].model).to eq(car1.model)
    end
  end

  describe 'sorting' do
    context 'with out labels and ranks' do
      let(:scores_data) { [] }

      it 'sorts by price' do
        expect(result[0].price).to eq(car2.price)
      end
    end

    context 'with out labels' do
      let(:scores_data) do
        [
          { car_id: car1.id, rank_score: 0.4 },
          { car_id: car2.id, rank_score: 0.5 }
        ]
      end

      it 'sorts by ranks' do
        expect(result[0].price).to eq(car2.price)
      end
    end

    context 'with user preferences' do
      let(:user) do
        create(
          :user,
          preferred_price_range: 30_000..50_000,
          preferred_brands: [toyota]
        )
      end
      let!(:car3) { create(:car, price: 25_687, brand: toyota) }

      it 'sorts by user preferences' do
        expect(result[0].price).to eq(car1.price)
      end

      it 'fills labels' do
        expect(result[0].label).to eq('perfect_match')
        expect(result[1].label).to eq('good_match')
        expect(result[2].label).to eq(nil)
      end
    end
  end
end
