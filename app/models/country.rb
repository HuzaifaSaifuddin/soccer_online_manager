class Country
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String

  def self.random_id
    pluck(:id).sample
  end
end
