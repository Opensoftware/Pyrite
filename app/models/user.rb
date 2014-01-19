class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable, :registerable

  serialize :preferences, Hash

  attr_accessible :email, :password, :password_confirmation, :remember_me

  # TODO check validations in devise and remove those:
  #validates_presence_of     :login, :email
  #validates_presence_of     :password,                   :if => :password_required?
  #validates_presence_of     :password_confirmation,      :if => :password_required?
  #validates_length_of       :password, :within => 4..40, :if => :password_required?
  #validates_confirmation_of :password,                   :if => :password_required?
  #validates_length_of       :login,    :within => 3..40
  #validates_length_of       :email,    :within => 3..100
  #validates_uniqueness_of   :login, :case_sensitive => false


  def admin?
    return true if email.present?
  end

end
