module IrReportMailSendable
  extend ActiveSupport::Concern

  def reported?
    self.mail_sent
  end

  def report
    ses = AWS::SES::Base.new(access_key_id: SES_ID,secret_access_key: SES_KEY)

    ses.send_email(
      :to        => 'ir@yamaokaya.com',
      :source    => 'info@yamaokaya.com',
      :subject   => "問い合わせメール(#{self.id})",
      :text_body => report_body
    )
    self.mail_sent = true
    self.save
  end

  def report_body
    ret = <<-EOS
    お名前:#{self.name}
    会社名:#{self.company_name}
    メールアドレス:#{self.mail_addr}
    ご住所:#{self.address}
    電話番号:#{self.phone}
    メッセージ: -
    #{self.message}
    EOS
    ret.gsub(/^\s+/,'')
  end
end