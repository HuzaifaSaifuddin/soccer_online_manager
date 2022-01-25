class Player
  include Mongoid::Document
  include Mongoid::Timestamps

  field :first_name, type: String
  field :last_name, type: String
  field :age, type: Integer

  field :position, type: String
  field :market_value, type: Float, default: 1000000

  field :transfer, type: Boolean, default: false
  field :transfer_value, type: Float, default: 0.0

  belongs_to :team
  belongs_to :country

  validates_presence_of :first_name, :last_name, :age, :position
  validates :age, inclusion: { in: (18..40).to_a, message: 'should be between 18 to 40' }
  validates :position, inclusion: { in: %w[goalkeeper defender midfielder attacker],
                                    message: 'should be goalkeepers, defenders, midfielders or attackers' }

  def full_name
    "#{first_name} #{last_name}"
  end
end
