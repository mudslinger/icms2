#coding:utf-8
class UserMailer < ActionMailer::Base
  default :from => "logger@izumo.ne.jp"
  
  def hikae_email(user)
    #@user = user
    @url  = "http://example.com/login"
    mail(:to => 'kawahara.shinya@izumo-it.co.jp',
    #:to => 'it-net@ezweb.ne.jp',
         :subject => "枝野幸男官房長官は15日午前の記者会見で、東京電力福島第1原発3号機付近で放射性物質400ミリシーベルトが確認されたと明らかにした。")
  end
  
  def syounin_irai(user, entry)
    @user = user
    @entry = entry
    #@url = "http://" + request.headers["HTTP_HOST"] + edit_entry_path(entry)
    @url = File.join("" + AppConfig.get("base_url") , edit_entry_path(entry))
    mail(:to => "#{user.name} <#{user.emailaddress}>",
          :from => "#{user.name} <#{user.emailaddress}>",
         :subject => "記事承認依頼:##{entry.id}")
  end
  
  def notify_on_post(user, author, entry)
    @user = user
    @entry = entry
    #@url = "http://" + request.headers["HTTP_HOST"] + edit_entry_path(entry)
    @url = File.join("" + AppConfig.get("base_url") , entry_path(entry))
    mail(:to => "#{user.name} <#{user.emailaddress}>",
          :from => "#{author.name} <#{author.emailaddress}>",
         :subject => "#{entry.title}")
  end
  
  
end
