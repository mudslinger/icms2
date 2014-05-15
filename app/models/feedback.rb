class Feedback < ActiveRecord::Base
  include FeedbackReportable
  validates :name,presence: true
  validates :mail_addr,{
    presence: true,
    confirmation: true,
    format: {
      with: /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/}
  }
  validates :mail_addr_confirmation,presence:true
  belongs_to :shop
  belongs_to :menu
  scope :not_sent, -> { where(mail_sent: false)}
  attr :mail_addr_confirmation

  def message_i
    tagger = Igo::Tagger.new(DIC_ADDRESS)
    t = tagger.parse(self.message) if self.message.present?
    t.map{|m|
      m.feature.include?('固有') ? '●●●' : m.surface
    }.join if t.present?
  end
end
