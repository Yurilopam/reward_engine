class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.integer :total_score
      t.integer :login_streak
      t.date :last_login_date

      t.timestamps
    end
  end
end
