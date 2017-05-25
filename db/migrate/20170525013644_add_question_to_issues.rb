class AddQuestionToIssues < ActiveRecord::Migration[5.1]
  def change
    add_column :issues, :question, :string
  end
end
