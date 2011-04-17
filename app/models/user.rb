# == Schema Information
# Schema version: 20110417230516
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  :presence => true,
                    :length   => { :maximum => 50 }
  validates :email, :presence => true,
                    :format   => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
  
  # Automatically create the virtual attr 'password_confirmation'
  validates :password,  :presence     => true,
                        :confirmation => true,
                        :length       => { :within => 6..40 }

  before_save :encrypt_password

  private
    
    def encrypt_password
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      string # temporary implementation!
    end

end
