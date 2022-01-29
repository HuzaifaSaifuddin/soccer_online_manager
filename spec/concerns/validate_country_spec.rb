require 'spec_helper'

shared_examples_for 'validate_country' do
  let(:model) { described_class } # the class that includes the concern

  it 'raises country code not found error' do
    country_model = FactoryBot.build(model.to_s.underscore.to_sym, country_id: 'xx')
    country_model.save

    message = 'Country code not in the list. Refer /api/v1/countries to get a list of country codes'
    expect(country_model.errors.full_messages[0]).to eq(message)
  end

  it 'doesnt raise error if country code is correct' do
    country_model = FactoryBot.build(model.to_s.underscore.to_sym, country_id: 'in')
    country_model.save
    expect(country_model.errors.full_messages).to eq([])
  end

  it 'doesnt raise not found error if country code is empty' do
    country_model = FactoryBot.build(model.to_s.underscore.to_sym, country_id: '')
    country_model.save
      expect(country_model.errors.full_messages[0]).to eq("Country can't be blank")
  end
end
