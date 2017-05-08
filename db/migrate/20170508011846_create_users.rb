class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :name
      t.string :avatar_url
      t.string :email
      t.string :provider, null: false
      t.string :uid, null: false
      t.string :oauth_token

      t.timestamps
    end
  end
end
