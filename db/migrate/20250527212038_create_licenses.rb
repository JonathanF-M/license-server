class CreateLicenses < ActiveRecord::Migration[7.2]
  def change
    create_table :licenses do |t|
      t.string :user
      t.string :asset_id
      t.datetime :issued_at

      t.timestamps
    end
  end
end
