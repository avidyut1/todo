class CreateTodoitems < ActiveRecord::Migration[5.0]
  def change
    create_table :todoitems do |t|
      t.string :text
      t.boolean :completed
      t.timestamps
    end
  end
end
