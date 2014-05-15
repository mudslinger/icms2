module Manageable
  extend ActiveSupport::Concern

  def mail_addrs
    {
      group: "s#{self.new_id}@yamaokaya.com",
      manager: "s#{self.new_id}-man@yamaokaya.com",
      sv: "s#{self.new_id}-sv@yamaokaya.com"
    }
  end

end