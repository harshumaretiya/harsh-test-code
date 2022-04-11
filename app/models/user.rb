# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :invitable, :confirmable
  rolify

  #Define Role
  enum role: [:owner, :staff].freeze

  #Associations
  has_one :owner, class_name: 'User', foreign_key: 'owner_id'
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id', optional: true
end
