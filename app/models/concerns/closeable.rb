module Closeable
  extend ActiveSupport::Concern

  def closed?
    self.close < Date.today
  end

end