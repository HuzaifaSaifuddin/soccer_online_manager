class Team
  include Mongoid::Document
  include Mongoid::Timestamps
  include ValidateCountry

  field :name, type: String
  field :balance, type: Float, default: 5_000_000.0

  validates_presence_of :name
  validates_numericality_of :balance, greater_than_or_equal_to: 0.0

  belongs_to :user
  belongs_to :country

  has_many :players

  after_validation :validate_country_code, if: :country_id_changed?

  def value
    players.pluck(:market_value).sum
  end
end
