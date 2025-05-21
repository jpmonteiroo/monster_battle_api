class CreateMonsters < ActiveRecord::Migration[7.1]
  def change
    create_table :monsters do |t|
      t.string :imageUrl
      t.string :name
      t.integer :attack
      t.integer :defense
      t.integer :hp
      t.integer :speed

      t.timestamps
    end
  end
end
