class User < ApplicationRecord
  has_many :appliances
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
    UserMailer.user_welcome_email(self, token).deliver
  end
end
