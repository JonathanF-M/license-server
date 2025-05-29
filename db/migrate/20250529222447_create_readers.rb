class CreateReaders < ActiveRecord::Migration[7.2]
  def change
    create_table :readers do |t|
      t.text :public_key
      t.datetime :registered_at

      t.timestamps
    end
  end
end
