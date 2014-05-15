module Spoilable
  extend ActiveSupport::Concern

  def new?
    10.days.ago < self.sell_from
  end

end