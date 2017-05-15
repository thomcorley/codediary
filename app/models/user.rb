class User < ApplicationRecord
  has_many :entries

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email_address, presence: true

  validates :first_name, uniqueness: true
  validates :last_name, uniqueness: true
  validates :email_address, uniqueness: true

  has_many :searches
  
end
