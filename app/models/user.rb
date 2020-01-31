class User < ApplicationRecord
  has_many :appliances, dependent: :destroy
  has_many :sources, through: :appliances
  has_many :batteries, dependent: :destroy
  has_many :communication_modules, dependent: :destroy
  has_many :power_systems, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :project_appliances, through: :projects
  has_many :solar_systems, through: :projects
  has_many :solar_panels, dependent: :destroy
  has_many :uses, dependent: :destroy

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
      name: "LED bulb 5W",
      description: "Efficient LED bulb.",
      current_type: "AC",
      power: 5,
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
    source1.save
    appliance2 = self.appliances.new(
      use_id: use2.id,
      name: "Chest freezer 200L",
      description: "Very efficient chest freezer.",
      current_type: "AC",
      power: 80,
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
    powerSystem1 = self.power_systems.new(
      name: "VICTRON Easysolar 24/3000",
      mppt: "Victron 150/70",
      system_voltage: 24,
      power_in_min: 500,
      power_in_max: 2000,
      ac_out: true,
      inverter: "Victron Multiplus 24/3000",
      power_out_max: 3000,
      voltage_out_min: 220,
      voltage_out_max: 240,
      price_min_cents: 127500,
      price_max_cents: 180000,
      currency: "eur",
      price_min_eur_cents: 127500,
      price_max_eur_cents: 180000,
      lifetime: 15
      )
    powerSystem1.save
    powerSystem2 = self.power_systems.new(
      name: "Custom Power Pack",
      mppt: "Victron 150/85",
      system_voltage: 24,
      power_in_min: 500,
      power_in_max: 2000,
      ac_out: false,
      inverter: nil,
      power_out_max: 2000,
      voltage_out_min: 12,
      voltage_out_max: 24,
      price_min_cents: 100000,
      price_max_cents: 150000,
      currency: "eur",
      price_min_eur_cents: 100000,
      price_max_eur_cents: 150000,
      lifetime: 15
      )
    powerSystem2.save
    solarPanel1 = self.solar_panels.new(
      technology: "Polycristalline",
      power: 270,
      price_min_cents: 14000,
      price_max_cents: 18000,
      currency: "eur",
      price_min_eur_cents: 14000,
      price_max_eur_cents: 18000,
      lifetime: 15
      )
    solarPanel1.save
    battery1 = self.batteries.new(
      technology: "Lead acid - Sealed GEL / 0PzV",
      voltage: 12,
      capacity: 200,
      dod: 50,
      efficiency: 80,
      price_min_cents: 25000,
      price_max_cents: 40000,
      currency: "eur",
      price_min_eur_cents: 25000,
      price_max_eur_cents: 40000,
      lifetime: 5
      )
    battery1.save
    battery2 = self.batteries.new(
      technology: "Lithium",
      voltage: 12,
      capacity: 200,
      dod: 80,
      efficiency: 95,
      price_min_cents: 130000,
      price_max_cents: 210000,
      currency: "eur",
      price_min_eur_cents: 130000,
      price_max_eur_cents: 210000,
      lifetime: 10
      )
    battery2.save
    communicationModule1 = self.communication_modules.new(
      power: 15,
      price_min_cents: 40000,
      price_max_cents: 50000,
      currency: "eur",
      price_min_eur_cents: 40000,
      price_max_eur_cents: 50000,
      lifetime: 15
      )
    communicationModule1.save
    project1 = self.projects.new(
      name: "Freezing kiosk",
      description: "Small kiosk offering cold storage services.",
      country_code: "FR",
      city: "Bordeaux",
      day_time: "7:00".to_time,
      night_time: "19:00".to_time,
      voltage_min: 200,
      voltage_max: 230,
      frequency: "50 Hz",
      current_ac: true,
      current_dc: false,
      wiring: true,
      token: SecureRandom.hex,
      grid_connection_charge_cents: 5000,
      grid_subscription_charge_cents: 2000,
      grid_consumption_charge_cents: 15,
      diesel_price_cents: 100,
      currency: "eur",
      grid_connection_charge_eur_cents: 5000,
      grid_subscription_charge_eur_cents: 2000,
      grid_consumption_charge_eur_cents: 15,
      diesel_price_eur_cents: 100
      )
    project1.save
    projectAppliance1 = project1.project_appliances.new(
      appliance_id: appliance1.id,
      quantity: 3,
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
    projectAppliance1.save
    projectAppliance2 = project1.project_appliances.new(
      appliance_id: appliance2.id,
      quantity: 1,
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
    projectAppliance2.save
    solarSystem1 = project1.solar_systems.new(
      solar_panel_id: solarPanel1.id,
      battery_id: battery1.id,
      power_system_id: powerSystem1.id,
      communication_module_id: communicationModule1.id,
      system_voltage: 24,
      communication: true,
      autonomy: 1
      )
    solarSystem1.save
  end

end
