#coding:utf-8
module ContentsCacheManager
  
  
  
  
  #
  #すべて
  #
  def sweep_all_contents_cache
    
    #すべてのカテゴリ
    Form.all.each{|frm|
      name = frm.template_name
      frm.entries.each{|entry|
        #詳細ページ
        sweep_entry_detail_for(name,entry)
      }
      #インデックス
      sweep_category_indexes_for(name)
      
      #ヘッドライン
      sweep_category_headline_for(name)
    }
    #念のためカテゴリ定義が存在しない時用
    sweep_category_headline_for("job")
    sweep_category_headline_for("topics")
    sweep_category_headline_for("seminar")
    sweep_category_headline_for("genki_kigyou")
    
    #RSS
    only_sweep_category_headline_for_rss
    #トップ
    sweep_top_page_cache
  end
  
  #
  #インデックス
  #
  def sweep_category_indexes_for(name)
      #インデックス(1ページ目)
      expire_page(contents_index_path(:name => name))
            
      #総ページ数がわからない
      page_path = contents_page_path(:name => name, :page => 997)
      glob_path = File.join(Rails.public_path, File.dirname(page_path),File.basename(page_path).sub(/997/, '*'))
      logger.debug "ページファイル一括指定：#{glob_path}"
      Dir.glob(glob_path).each{|index_file|
        index_file_to_expire = index_file.gsub(Rails.public_path, '')
        logger.debug "消尽:#{index_file_to_expire}"
        expire_page index_file_to_expire
      }
    
  end
  
  #
  #ヘッドライン
  #
  def sweep_category_headline_for(name)
    #↓キャッシュしない設定になっていると、以前のキャッシュが残っていても常にfalseを返す
    if fragment_exist? "headline_#{name}"
      expire_fragment("headline_#{name}")
    end  
  end
  
  #
  #RSS
  #
  def sweep_category_headline_for_rss
    only_sweep_category_headline_for_rss
    #トップページ
    sweep_top_page_cache    
  end
  
  
  #
  #詳細
  #
  def sweep_entry_detail_for(name,entry)
    expire_page(contents_detail_path(:name => name, :id => entry.id))
  end
  
  #
  #トップページ
  #
  def sweep_top_page_cache
    expire_page(root_path)    
  end
  
  
  private
  def expire_cache_for(entry)
    #新しいページが追加されたので、インデックスページを失効させる
    name = entry.form.template_name
    if name == "job"
      #左メニュー新着はあらゆるページに含まれる。
     sweep_all_contents_cache 
      
    else
      
      #詳細
      sweep_entry_detail_for(name,entry)
      
      #インデックス
      sweep_category_indexes_for(name)    
      
      #フラグメントの失効 Expire a fragment
      sweep_category_headline_for(name)
      
      #トップページ
      sweep_top_page_cache
    end
    
  end  
  
  def only_sweep_category_headline_for_rss
    if fragment_exist? "headline_rss"
      expire_fragment("headline_rss")
    end    
  end
  
end