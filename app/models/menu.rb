class Menu < ActiveRecord::Base
  include Spoilable
  belongs_to :genre,foreign_key: :genre_id
  has_many :feedbacks
  scope :state, ->(state){
    case state
    when :active then
      where(
        "(current_timestamp between sell_from and sell_to) or " +
        "(current_timestamp between promotion_from and promotion_to)"
      ).sort
    when :inactive then
      where(
        "not(current_timestamp between sell_from and sell_to) and " +
        "not(current_timestamp between promotion_from and promotion_to)"
      ).sort
    end
  }
  scope :heavy_lotation, ->(page){
    state(:active).
    where("push_priority is not null").
    #where(:page,page).
    order(:push_priority).
    first
  }
  scope :sort, ->{
    order(:sell_from)
  }

end
