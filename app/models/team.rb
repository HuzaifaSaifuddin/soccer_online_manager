class Team
  include Mongoid::Document
  include Mongoid::Timestamps
  include ValidateCountry

  field :name, type: String
  field :balance, type: Float, default: 5000000

  validates_presence_of :name

  belongs_to :user
  belongs_to :country

  has_many :players

  after_validation :validate_country_code

  def value
    players.pluck(:market_value).sum
  end
end
