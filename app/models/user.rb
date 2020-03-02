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

  include Seeding

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true

  after_create :send_welcome_email
  after_create :seed_user

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

end
