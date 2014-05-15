#coding:utf-8

class WelcomeController < ApplicationController
  skip_before_filter :site_protected
  skip_before_filter :login_required, :only => [:sweep_cache_trigger]
  
  def menu
    
  end
  

  include ContentsCacheManager
  
  #手動キャッシュクリアー
  def sweep_cache
    
    sweep_all_contents_cache
    flash[:notice] = "クリアー"
    redirect_to admin_extra_menu_path

    #テンプレートキャッシュのクリア
    #キャッシュはプロセスごとに固有のため、この方法では本番環境ではすべてクリアできない
#    view_paths.each{|v|
#      v.clear_cache
#    }
    
  end
  
  #cron
  #url:  http://kawaharakaihatu.lan.izumo.ne.jp:3000/admin/triggers/sweep_cache
  #*/15 * * * * /home/kawahara/public_html/workspace4/icms/lib/tasks/sweep_cache_trigger.sh
  def sweep_cache_trigger
    trigger_log "トリガーの呼び出し:#{Time.now}>>>>>"
    #指定した時間範囲において、公開開始になるか、公開終了になるものを列挙
    #時間範囲：前回のtask実行日時～現在
    ac = AppConfig.first
    to = round_sec(Time.now)
    from = ac.cron1_triggered_at
    
    #日付範囲は境界を含むため前回実行時と今回実行時の２回マッチしてしまう。1秒追加
    from += 1
    
    trigger_log("検索時間範囲:#{from} - #{to}")
    
    entries = Entry.date_event_article(from, to)


    
    trigger_log("件数:#{entries.size}")
    
    entries.each{|entry|
      trigger_log "該当:#{entry.id},#{entry.title}"
      expire_cache_for(entry)
    }
      #render :file => File.join(Rails.public_path, "500.html") , :status => 404, :layout => nil
      ac.cron1_triggered_at = to
      ac.save!
      
      #RSSトリガ
      sweep_cache_rss_trigger
      trigger_log "<<<<<トリガーの呼び出し終了:#{Time.now}"
      render :text => "success#{@trigger_log}"
  end
  
  #
  #リロード
  #
  def reload
    system "touch #{File.join(Rails.root,'tmp','restart.txt')}"
    flash[:notice] = "reload"
    redirect_to admin_extra_menu_path    
  end
  
  #
  #管理用URLを/admin -> /manager に変更したことに対する互換性維持のため
  #
  def manage_legacy
    next_path = request.headers["REQUEST_URI"].sub(/\/admin/, "/manager")
    redirect_to next_path
    
  end
  
  
  def geocode_picker
    render  :layout => nil
  end    
  
  private
  #
  #トリガログ
  #
  def trigger_log(message)
    @trigger_log ||= ""
    @trigger_log << message + "\n"
    logger.info(message)
  end
  
  #
  #
  #
  def round_sec(tm)
    Time.mktime(tm.year, tm.month, tm.day, tm.hour, tm.min, 0)
    
  end  

  #↓ベーシック認証する場合
#  USERNAME, PASSWORD = "humbaba", "5baa61e4"
# 
#  before_filter :simple_authenticate, :only => [:sweep_cache_trigger]
# 
#  private
# 
#  def simple_authenticate
#    authenticate_or_request_with_http_basic do |username, password|
#      logger.debug "simple_authenticate: #{username},#{password}"
#      #dig_pass =Digest::SHA1.hexdigest(password)
#      #logger.debug "dig_pass = #{dig_pass}"
#      username == USERNAME && password == PASSWORD
#    end
#  end  
  

  #
  #RSS
  #
  def sweep_cache_rss_trigger
    
    logger.debug "sweep_cache_rss開始"
    
    
    
    
    rss_url = AppConfig.get("misato_rss_url")
    return if rss_url.blank?
    url = URI.parse(rss_url)
    
    begin
      
      
      Net::HTTP.start(url.host) {|http|
        
        response = http.head(url.path)
        if response.code == "200" # || response.code == "304" #なぜか304が返ってくることがある。この場合更新日付が入っていない
          
          last_modified = Time.parse(response['last-modified'])
          last_expired_at = Rails.cache.read 'headline_rss_last_expired_at'
          last_expired_at ||= last_modified
          
          logger.debug "last_expired_at=#{last_expired_at}, last_modified=#{last_modified}"
          
          if last_modified >= last_expired_at
            logger.info "RSS更新する"
            sweep_category_headline_for_rss
            Rails.cache.write('headline_rss_last_expired_at', Time.now)
            else
            logger.info "RSS更新しない"
          end
        else
          logger.info "response.code=#{response.code}"
        end
        
      }
    rescue => evar
      logger.info "sweep_cache_rssエラー：#{evar}"
     raise evar 
    end
  end
  


  
  #
  #
  #  
  def recreate_versions
    fields = %w(pic_main
pic_small1
pic_small2
pic_small3
pic_small4
pic_small5
pic_small6
pic_small7
pic_small8
pic_small9
pic_small10
pic_small11
pic_small12
pic_small13
pic_small14
pic_small15
pic_small16
pic_madori
pic_gairyaku
)
    
    
    Entry.transaction do
      
      Entry.where(:form_id => 10).each do |e|
        
        fields.each do |f|
          pic = e._cf(f)
          if pic
            unless pic.blank?
              puts "#{pic}"
              pic.recreate_versions!
            end
          end
          
        end
        
      end
      
      
      
    end    
  end
  
end
