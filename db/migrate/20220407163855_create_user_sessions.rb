# frozen_string_literal: true

class CreateUserSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :user_sessions, id: :uuid do |t|
      t.string :platform
      t.string :token
      t.references :user, null: false, foreign_key: true, type: :uuid  
      t.timestamps
    end
  end
end
