class CreateRegexes < ActiveRecord::Migration[7.0]
  def change
    create_table :regexes do |t|
      t.string :title

      t.timestamps
    end
  end
end
