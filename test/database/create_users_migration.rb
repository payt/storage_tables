# frozen_string_literal: true

class CreateUsersMigration < ActiveRecord::Migration[7.0]
  def change
    create_table :users, force: :cascade do |t|
      t.string :name
      t.timestamps
    end
  end
end
