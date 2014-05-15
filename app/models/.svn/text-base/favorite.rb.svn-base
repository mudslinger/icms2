class Favorite < ActiveRecord::Base
#  attr_accessible :entry_id, :user_id
  belongs_to :entry
  scope :user_favorites, lambda{|user|
   now = Time.now
   where(:user_id => user.id).includes(:entry).
      joins("INNER JOIN entries ON entries.id=favorites.entry_id  ").
      where(Entry.sql_valid_article, now, now, now)
  
  }
  
end
