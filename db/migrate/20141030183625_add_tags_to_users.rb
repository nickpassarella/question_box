class AddTagsToUsers < ActiveRecord::Migration
  def change
    create_join_table :tags, :users
  end
end
