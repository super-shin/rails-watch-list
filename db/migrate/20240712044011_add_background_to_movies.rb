class AddBackgroundToMovies < ActiveRecord::Migration[7.1]
  def change
    add_column :movies, :background, :string
  end
end
