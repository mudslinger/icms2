#coding:utf-8

class ContentsCacheSweeper < ActionController::Caching::Sweeper
  observe Entry # このスイーパはProductモデルを注視します。 This sweeper is going to keep an eye on the Product model
  include ContentsCacheManager
  
  # もしスイーパがProductのcreateを検出したらこのメソッドを呼ぶ If our sweeper detects that a Product was created call this
  def after_create(entry)
    expire_cache_for(entry)
  end
  
  #update
  def after_update(entry)
    expire_cache_for(entry)
  end
  
  #destroy
  def after_destroy(entry)
    expire_cache_for(entry)
  end
  

  
  
end
