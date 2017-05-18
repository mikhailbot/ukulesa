class AddSentWelcomeEmailToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :sent_welcome_email, :boolean
  end
end
