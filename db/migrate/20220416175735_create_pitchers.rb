class CreatePitchers < ActiveRecord::Migration[7.0]
  def change
    create_table :pitchers do |t|
      t.string :name
      t.string :team
      t.string :opp1
      t.string :opp2
      t.decimal :value

      t.timestamps
    end
  end
end
