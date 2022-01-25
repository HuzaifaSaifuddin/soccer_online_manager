class Team
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :balance, type: Float, default: 5000000

  validates_presence_of :name

  belongs_to :user
  belongs_to :country

  has_many :players

  def value
    players.pluck(:market_value).sum
  end
end
