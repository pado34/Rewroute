class CreateUrls < ActiveRecord::Migration[5.1]
  def change
    create_table :urls do |t|
      t.text :source
      t.text :destination
      
	  
      t.references :user, foreign_key: true
	  
	  t.boolean :active, default: true
      t.timestamps
    end
	add_index :urls, [:user_id, :updated_at]
	add_index :urls, [:user_id, :destination], :length => {:destination => 255}
	add_index :urls, :source, unique: true, :length => {:source => 255}
    #had to add length to both of these above cause mysql needs that for text type indexes, its bad, i need to create another way, like store the url plaintext, then the hash, and
    #add and index on the hash therefore i get the text and the speed right?
  end
end
