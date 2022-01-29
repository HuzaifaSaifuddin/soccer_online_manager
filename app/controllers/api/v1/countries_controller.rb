class Api::V1::CountriesController < ApplicationController
  before_action :authorize

  def index
    countries = Country.all
    countries_list = countries.map { |c| { "#{c.id}": c.name } }.inject(:merge)

    render json: { countries: countries_list }, status: :ok
  end
end
