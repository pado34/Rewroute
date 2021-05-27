class Url < ApplicationRecord
  belongs_to :user
  default_scope -> { order(updated_at: :desc) }
  validates :user_id, presence: true
  validates :source,  presence: true, uniqueness: true
  validates :destination,  presence: true

  
  #add a limit to the length? also the uniqunesse true is a x2 verification on the db and on the view? meh
  #validates :source, presence: true, length: { maximum: 65536 }, uniqueness: true  
  #https://stackoverflow.com/questions/3354330/difference-between-string-and-text-in-rails
end
