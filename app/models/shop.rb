class Shop < ActiveRecord::Base
  include Gmappable,Closeable,Manageable
  has_and_belongs_to_many :areas,join_table: :area_details
  has_many :feedbacks
  scope :new_shops, ->{
    where("current_timestamp between (date_add(inauguration,interval -30 day)) and close").
    order('inauguration desc').limit(3)
  }
  scope :active, -> {
    where("(current_timestamp between inauguration and close) or (abs(datediff(current_timestamp,inauguration)) < 30)").
    order(:id)
  }
  scope :simple, -> {
    select(:id,:name,:phone,:address)
  }
  scope :nearest, ->(lat,lng,limit=4) {
    where("sqrt(power((lat*111-#{lat}*111),2)+ power((lng*91-#{lng}*91),2)) < 30").
    order("sqrt(power((lat*111-#{lat}*111),2)+ power((lng*91-#{lng}*91),2))").
    limit(limit)
  }
end
