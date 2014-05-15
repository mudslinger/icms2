warn "danger_patch loaded"


#production環境においても常にテンプレートをコンパイルしなおす
module ActionView
  # = Action View Resolver
  class Resolver
    
    def self.caching?
      false
    end
    private
    def caching?
      #@caching ||= !defined?(Rails.application) || Rails.application.config.cache_classes
      false
    end
  end
  
end

#utf8_to_sjisにおいて変換先が定義されていないとき'?'を表示
module Jpmobile
  module Util
     module_function
    def utf8_to_sjis(utf8_str)
      # 波ダッシュ対策
      utf8_str = wavedash_to_fullwidth_tilde(utf8_str)
      # オーバーライン対策(不可逆的)
      utf8_str = overline_to_fullwidth_macron(utf8_str)
      # ダッシュ対策（不可逆的）
      utf8_str = emdash_to_horizontal_bar(utf8_str)
      # マイナス対策（不可逆的）
      #↓スペルミスしている。バージョンによって違う。
      #utf8_str = minus_sign_to_fullwidth_pyphen_minus(utf8_str)
      utf8_str = minus_sign_to_fullwidth_hyphen_minus(utf8_str)
      

      if utf8_str.respond_to?(:encode)
        utf8_str.encode(SJIS, :crlf_newline => true, :undef => :replace)
      else
        NKF.nkf("-m0 -x -W --oc=cp932", utf8_str).gsub(/\n/, "\r\n")
      end
    end
 end
end

#Jpmobile::Emoticon::CONVERSION_TABLE_TO_SOFTBANK[0xE735] = "[recy]"
module ActiveRecord
  module SessionStore
    class Session < ActiveRecord::Base
      attr_accessible :session_id, :data
    end
  end
end

