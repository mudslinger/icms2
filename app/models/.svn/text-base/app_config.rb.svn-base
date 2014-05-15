class AppConfig < ActiveRecord::Base
  
  
  #
  #暫定
  #
  def self.get(key)
    
#    @@static_config ||= {
#    #"misato_rss_url" => "http://www.town.shimane-misato.lg.jp/rss/rss.xml"
#    "misato_rss_url" => "http://192.168.252.203/~kawahara/rss.xml"
#    
#    }

    @@static_config ||= YAML.load_file(File.join(Rails.root, "config", "app.yml"))
    @@static_config[key]
  end
  
  after_initialize do |obj|
    obj.maintenance_mode = self.class.fetch_maintenance_mode
  end
  
  after_save do |obj|
    self.class.update_maintenance_mode!(obj.maintenance_mode)
  end
  
  #
  #
  #
  def maintenance_mode
    @maintenance_mode
  end
  
  #
  #
  #
  def maintenance_mode=(mode)
    @maintenance_mode=mode
  end
  
  #
  #
  #
  def self.fetch_maintenance_mode
    self.maintenance_mode? ? "maintenance" : "normal"
  end
  
  #
  #
  #
  def self.update_maintenance_mode!(mode)
    if mode == "maintenance"
      File.open("#{Rails.root}/config/site_protected.txt", "w"){|f|
      }
    else
      FileUtils.rm_f("#{Rails.root}/config/site_protected.txt") 
    end
  end
  
  #
  #
  #
  def self.maintenance_mode?
    File.exists?("#{Rails.root}/config/site_protected.txt")
  end
  
end
