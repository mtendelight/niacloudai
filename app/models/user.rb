class User < ApplicationRecord
  attr_accessor :login

# Remove Devise length handling issue
# Remove Devise length handling issue
validates :password, length: { minimum: 6, maximum: 128 }, if: :password_present?
has_many :daily_tasks, dependent: :destroy

 validate :password_complexity

  has_many :sent_conversations,
           class_name: "Conversation",
           foreign_key: :sender_id,
           dependent: :destroy

  has_many :received_conversations,
           class_name: "Conversation",
           foreign_key: :recipient_id,
           dependent: :destroy

  has_many :messages, dependent: :destroy


    AI_USERNAME = "janomaxai".freeze

  def ai?
    username.to_s.downcase == AI_USERNAME
  end

  def self.ai_assistant
    find_by!("LOWER(username) = ?", AI_USERNAME)
  end

  # All chats
  def conversations
    Conversation.where("sender_id = ? OR recipient_id = ?", id, id)
  end

  # Devise modules
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :validatable, :confirmable, :timeoutable, :omniauthable, omniauth_providers: [:google_oauth2], :timeout_in => 30.minutes
  devise :timeoutable, :timeout_in => 30.minutes
  def login
    @login || self.username || self.email || self.phone_number || self.userdetails
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).where(
      ["lower(username) = :value OR lower(email) = :value OR lower(userdetails) = :value OR phone_number = :value", { value: login.strip.downcase }]
    ).first
  end


   def f_name
    "#{username} : #{email} : #{phone_number}"
  end
 has_many :orders
  
  # Ensure email is unique, ignoring case
  validates :email, uniqueness: { case_sensitive: false }
  validates :phone_number, presence: true, uniqueness: true, format: { with: /\A0\d{9,14}\z/, message: "must start with 0 and be between 10 to 15 digits long" }


  # Ensure username is unique, ignoring case

     #has_many :students, dependent: :destroy
      #has_and_belongs_to_many :roles

  has_many :user_sessions, dependent: :destroy
  #has_many :orders

   validates :username, presence: true, uniqueness: { case_sensitive: false }, on: :create
  
  attr_accessor :last_sign_in_at

  def update_last_sign_in_at!
    self.last_sign_in_at = current_sign_in_at
    save
  end

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :username
  #validates :username, presence: true
  #validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true
 

  # Define roles association
  has_and_belongs_to_many :roles

  # Define dynamic methods for roles
  [:admin, :staff, :root, :superadmin, :cashier, :waiter, :manager].each do |role|
    define_method("#{role}?") { roles.exists?(name: role.to_s) }
  end

    # Scope to find users by role name
  scope :with_role, ->(role_name) { 
    joins(:roles).where(roles: { name: role_name }).distinct
  }


  # Update last_sign_in_at
  def update_last_sign_in_at!
    self.last_sign_in_at = current_sign_in_at
    save
  end





 
private



def password_present?
  password.present?
end

def password_complexity
  return if password.blank?

  unless password.match(/^(?=.*[A-Za-z])(?=.*\d).{8,}$/)
    errors.add :password, 'must be at least 8 characters and include letters and numbers'
  end
end


end

