# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  describe '.associations' do
    it { is_expected.to belong_to(:category) }
  end

  describe '.validations' do
    it { is_expected.to validate_presence_of(:unit) }
    it { is_expected.to validate_presence_of(:import_date) }
    it { is_expected.to validate_presence_of(:upc) }
    it { is_expected.to validate_numericality_of(:weight).is_greater_than_or_equal_to(0) }
  end

  describe '#convert_to_kilograms' do
    context 'when unit is kilograms' do
      let(:product) { create(:product, unit: 'kilograms') }

      it 'does not update value of weight' do
        expect(product.convert_to_kilograms).to eq(product.weight)
      end
    end

    context 'when unit is pounds' do
      let(:product) { create(:product, unit: 'pounds') }

      it 'converts value of weight to pounds' do
        expect(product.convert_to_kilograms).to eq(Unit.new("#{product.weight} #{product.unit}")
          .convert_to('kilograms').to_s('%0.3f').split.first.to_f)
      end
    end

    context 'when unit is grams' do
      let(:product) { create(:product, unit: 'grams') }

      it 'converts value of weight to pounds' do
        expect(product.convert_to_kilograms).to eq(Unit.new("#{product.weight} #{product.unit}").convert_to('kilograms')
          .to_s('%0.3f').split.first.to_f)
      end
    end
  end
end
