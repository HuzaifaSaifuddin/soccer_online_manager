class Player
  include Mongoid::Document
  include Mongoid::Timestamps
  include ValidateCountry

  field :first_name, type: String
  field :last_name, type: String
  field :age, type: Integer

  field :position, type: String
  field :market_value, type: Float, default: 1_000_000.0

  field :transfer, type: Boolean, default: false
  field :transfer_value, type: Float, default: 0.0

  belongs_to :team
  belongs_to :country

  validates_presence_of :first_name, :last_name, :age, :position
  validates :age, inclusion: { in: (18..40).to_a, message: 'should be between 18 to 40' }
  validates :position, inclusion: { in: %w[goalkeeper defender midfielder attacker],
                                    message: 'should be goalkeepers, defenders, midfielders or attackers' }

  # This will change if in future the player's default market value changes.
  validates_numericality_of :market_value, greater_than_or_equal_to: 1_000_000.0

  validates_numericality_of :transfer_value, greater_than: 0.0, if: :transfer
  validates_numericality_of :transfer_value, equal_to: 0.0, unless: :transfer

  after_validation :validate_country_code, if: :country_id_changed?

  def full_name
    "#{first_name} #{last_name}"
  end
end
