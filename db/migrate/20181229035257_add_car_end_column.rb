class AddCarEndColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :car_end, :string
  end
end
