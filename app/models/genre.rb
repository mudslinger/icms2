class Genre < ActiveRecord::Base
  has_many :menus,->(record) {Menu.state(:active)}
  scope :find_by_page,  ->(p) {
    order_by_sort if p.to_i == 100
    where(page: p).order_by_sort unless p.to_i == 100
  }
  scope :order_by_sort, -> {order(:soat)}
end
