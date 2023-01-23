class RenameContentColumnToBlogs < ActiveRecord::Migration[6.1]
  def change
    rename_column :blogs, :content, :description
  end
end
