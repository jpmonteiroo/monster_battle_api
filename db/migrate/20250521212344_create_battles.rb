class CreateBattles < ActiveRecord::Migration[7.1]
  def change
    create_table :battles do |t|
      t.references :monsterA
      t.references :monsterB
      t.references :winner

      t.timestamps
    end
  end
end
