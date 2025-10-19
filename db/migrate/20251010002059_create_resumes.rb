class CreateResumes < ActiveRecord::Migration[8.0]
  def change
    create_table :resumes do |t|
      t.string :name
      t.string :title
      t.text :summary
      t.text :experience
      t.text :projects
      t.string :profile_image

      t.timestamps
    end
  end
end
