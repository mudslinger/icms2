module FeedbackReportable extend ActiveSupport::Concern

  def reported?
    self.mail_sent
  end
  def report
    ses = AWS::SES::Base.new(access_key_id: SES_ID,secret_access_key: SES_KEY)
    sub = "お客様よりメール #{self.shop.name}(No.#{self.id})" if self.shop
    sub = "お客様よりメール (No.#{self.id})" unless self.shop
    sub += '【要返信】' if self.reply
    ses.send_email(
      to: 'info@yamaokaya.com',
      source: 'info@yamaokaya.com',
      subject: sub,
      html_body: yield({type: :haml, locals: {body: self}, template: 'feedbacks/mail',layout: 'blank'})
    )

    ses.send_email(
      to: 'customer_message@yamaokaya.co.jp',
      #to: 'tanaka@yamaokaya.com',
      source: 'info@yamaokaya.com',
      subject: sub + '(個人情報削除済み)',
      html_body: yield({type: :haml, locals: {body: self}, template: 'feedbacks/mask_mail',layout: 'blank'}),
      text_body: yield({type: :erb, locals: {body: self},formats: :text, template: 'feedbacks/mask_mail_txt',layout: 'blank'})
    )
    self.mail_sent = true
    self.save(validate: false)
  end

  def static_map
    markers = []
    #住所を正しく入力している場合
    if self.address
      markers.push({
        location: self.address,
        color: "blue",
        label: "A"
      })
    end

    #店舗を選択している場合
    if self.shop
      markers.push({
        latitude: self.shop.lat,
        longitude: self.shop.lng,
        color: "red",
        label: "Y"
      })
    end

    #緯度経度が特定される場合
    if self.shop
      markers.push({
        latitude: self.lat,
        longitude: self.lng,
        color: "green",
        label: "C"
      })
    end
    StaticMap::Image.new(
      {
        size: '300x300',
        sensor: false,
        #center: "#{self.zip} #{self.address}",
        markers: markers,
        maptype: 'road',
        zoom: 11
      }
    )
  end
end
