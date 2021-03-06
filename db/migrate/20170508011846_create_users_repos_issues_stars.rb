class CreateUsersReposIssuesStars < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :name
      t.string :avatar_url
      t.string :email
      t.string :provider, null: false
      t.string :uid, null: false
      t.string :oauth_token
      t.integer :notification_schedule, default: 1
      t.datetime :last_notified, default: -> { 'CURRENT_TIMESTAMP' }

      t.timestamps
    end

    create_table :repos do |t|
      t.string :name
      t.string :full_name, index: true
      t.string :owner_name
      t.integer :owner_id
      t.string :avatar_url
      t.datetime :last_checked

      t.timestamps
    end

    create_table :issues do |t|
      t.integer :number
      t.string :title
      t.string :answer
      t.string :link
      t.datetime :closed_at
      t.belongs_to :repo, index: true

      t.timestamps
    end

    create_table :stars do |t|
      t.belongs_to :user, index: true
      t.belongs_to :repo, index: true

      t.timestamps
    end
  end
end
