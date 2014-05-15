class IrMessage < ActiveRecord::Base
  include IrReportMailSendable
  self.table_name = 'ir_messages2'
  validates :name,
    presence: true
  validates :mail_addr,{
    presence: true,
    format: {
      with: /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/}
  }
  validates :message,
    presence: true

  scope :not_sent, -> { where(mail_sent: false  )}

end
