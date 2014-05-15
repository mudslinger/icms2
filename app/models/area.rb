class Area < ActiveRecord::Base
  has_and_belongs_to_many :shops,->(record) {Shop.active},join_table: :area_details
  scope :sorted, -> {order(:soat_order)}
  scope :level1, -> {where(level: 1)}
  scope :active, -> {includes(:shops).merge(Shop.active)}
end
