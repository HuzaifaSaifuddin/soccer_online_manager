module ValidateCountry
  def validate_country_code
    return if country_id.nil? || Country.find_by(id: country_id)

    errors.delete(:country)
    errors.add(:country, 'code not in the list. Refer /api/v1/countries to get a list of country codes')
  end
end
