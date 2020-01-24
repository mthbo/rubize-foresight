class User < ApplicationRecord
  has_many :appliances
  has_many :sources, through: :appliances
  has_many :batteries
  has_many :communication_modules
  has_many :distributions
  has_many :power_systems
  has_many :projects
  has_many :project_appliances, through: :projects
  has_many :solar_systems, through: :projects
  has_many :solar_panels
  has_many :uses

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true

  after_create :send_welcome_email
  after_create :create_default_data

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    approved? ? super : :not_approved
  end

  private

  def send_welcome_email
    token, enc_token = Devise.token_generator.generate(self.class, :reset_password_token)
    self.reset_password_token   = enc_token
    self.reset_password_sent_at = Time.now.utc
    self.save(validate: false)
    UserMailer.with(user: self, token: token).welcome.deliver_now
  end

  def create_default_data
    use1 = self.uses.new(
      name: "Lighting",
      hourly_rate_0: "",
      hourly_rate_1: "",
      hourly_rate_2: "",
      hourly_rate_3: "",
      hourly_rate_4: "",
      hourly_rate_5: "",
      hourly_rate_6: "10",
      hourly_rate_7: "10",
      hourly_rate_8: "",
      hourly_rate_9: "",
      hourly_rate_10: "",
      hourly_rate_11: "",
      hourly_rate_12: "",
      hourly_rate_13: "",
      hourly_rate_14: "",
      hourly_rate_15: "",
      hourly_rate_16: "",
      hourly_rate_17: "5",
      hourly_rate_18: "10",
      hourly_rate_19: "10",
      hourly_rate_20: "10",
      hourly_rate_21: "10",
      hourly_rate_22: "10",
      hourly_rate_23: "5"
      )
    use1.save
    use2 = self.uses.new(
      name: "Freezing",
      hourly_rate_0: "8",
      hourly_rate_1: "8",
      hourly_rate_2: "7",
      hourly_rate_3: "7",
      hourly_rate_4: "7",
      hourly_rate_5: "8",
      hourly_rate_6: "8",
      hourly_rate_7: "7",
      hourly_rate_8: "7",
      hourly_rate_9: "7",
      hourly_rate_10: "9",
      hourly_rate_11: "9",
      hourly_rate_12: "9",
      hourly_rate_13: "7",
      hourly_rate_14: "8",
      hourly_rate_15: "8",
      hourly_rate_16: "9",
      hourly_rate_17: "9",
      hourly_rate_18: "8",
      hourly_rate_19: "8",
      hourly_rate_20: "9",
      hourly_rate_21: "10",
      hourly_rate_22: "8",
      hourly_rate_23: "8"
      )
    use2.save
    appliance1 = self.appliances.new(
      use_id: use1.id,
      name: "LED bulb",
      description: "Standard LED bulb.",
      current_type: "AC",
      power: 10,
      power_factor: 1,
      starting_coefficient: 1,
      voltage_min: 220,
      voltage_max: 240,
      frequency_fifty_hz: true,
      frequency_sixty_hz: false,
      photo: "",
      energy_grade: "",
      hourly_rate_0: "",
      hourly_rate_1: "",
      hourly_rate_2: "",
      hourly_rate_3: "",
      hourly_rate_4: "",
      hourly_rate_5: "",
      hourly_rate_6: "10",
      hourly_rate_7: "10",
      hourly_rate_8: "",
      hourly_rate_9: "",
      hourly_rate_10: "",
      hourly_rate_11: "",
      hourly_rate_12: "",
      hourly_rate_13: "",
      hourly_rate_14: "",
      hourly_rate_15: "",
      hourly_rate_16: "",
      hourly_rate_17: "5",
      hourly_rate_18: "10",
      hourly_rate_19: "10",
      hourly_rate_20: "10",
      hourly_rate_21: "10",
      hourly_rate_22: "10",
      hourly_rate_23: "5"
      )
      appliance1.save
    source1 = appliance1.sources.new(
      supplier: "My supplier",
      issued_at: DateTime.now,
      details: "Price excluding VAT.",
      country_code: "FR",
      city: "Bordeaux",
      price_cents: 400,
      currency: "eur",
      discount_rate: 10,
      price_eur_cents: 400
      )
    source2.save
    appliance2 = self.appliances.new(
      use_id: use2.id,
      name: "Chest freezer 300L",
      description: "Very efficient chest freezer.",
      current_type: "AC",
      power: 110,
      power_factor: 0.85,
      starting_coefficient: 4,
      voltage_min: 220,
      voltage_max: 240,
      frequency_fifty_hz: true,
      frequency_sixty_hz: true,
      photo: "",
      energy_grade: "A++",
      hourly_rate_0: "8",
      hourly_rate_1: "8",
      hourly_rate_2: "7",
      hourly_rate_3: "7",
      hourly_rate_4: "7",
      hourly_rate_5: "8",
      hourly_rate_6: "8",
      hourly_rate_7: "7",
      hourly_rate_8: "7",
      hourly_rate_9: "7",
      hourly_rate_10: "9",
      hourly_rate_11: "9",
      hourly_rate_12: "9",
      hourly_rate_13: "7",
      hourly_rate_14: "8",
      hourly_rate_15: "8",
      hourly_rate_16: "9",
      hourly_rate_17: "9",
      hourly_rate_18: "8",
      hourly_rate_19: "8",
      hourly_rate_20: "9",
      hourly_rate_21: "10",
      hourly_rate_22: "8",
      hourly_rate_23: "8"
      )
      appliance2.save
      source2 = appliance2.sources.new(
        supplier: "My supplier",
        issued_at: DateTime.now,
        details: "Price excluding VAT.",
        country_code: "FR",
        city: "Bordeaux",
        price_cents: 50000,
        currency: "eur",
        discount_rate: 15,
        price_eur_cents: 50000
        )
      source2.save
  end

end
