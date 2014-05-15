#coding:utf-8
class User < ActiveRecord::Base
  acts_as_authentic do |c|
#    logger.info "http basic authをおふにします"
#    c.allow_http_basic_auth= false
  end
  
  has_many :form_permissions, :dependent => :destroy
  has_many :permitted_forms, :through => :form_permissions, :source => :form
  has_many :favorites, :dependent => :destroy
  
  validates_uniqueness_of :login
  validates_uniqueness_of :name
  validates_presence_of :name
  validates_presence_of :login
  validates_uniqueness_of :fb_id, :message => ":このIDは既に使われています。", :allow_blank => true
  
  validates_format_of :emailaddress,  :with => /.+@.+/ , :message => ":正しくありません", :allow_blank => true
  
  attr_protected :crypted_password, :password_salt, :persistence_token, :single_access_token, :perishable_token
  
  paginates_per 5
  
  def self.user_level_map
    #@@user_level_map ||= [nil, "一般", "承認権", "管理設定"]
    @@user_level_map ||= { 1 => "投稿者",  4 => "編集者", 2 => "承認権者", 3 => "管理者"}
  end
  
  #
  #デフォルトユーザーの雛形
  #
  def self.new_default_user(params)
    user = self.new(params)
    #user.user_level = 1
    return user
  end
  
  def user_level_label
    self.class.user_level_map[user_level]
  end
  
  #
  #承認権限をもつ
  #
  def has_syounin_kengen?
    [2,3].include?(user_level)
  end  
  
  #atumari暫定
  #
  def has_privilege?
    #↓atumariでの仕様
    #[2,3].include?(user_level)
    user_level == 3
  end
  
  #
  #他者が作成した記事の更新権限をもつ
  #
  def can_write_others_file?
    [2,3,4].include?(user_level)
  end
  
  #
  #作成者が自分以外の記事を閲覧可能
  #
  def can_read_others_file?
    user_level != 1
  end

  #
  #ユーザーが閲覧可能なカテゴリのリスト
  #
  def browsable_forms
    if has_privilege?
      Form.order("id")
    else
      permitted_forms
    end
  end
  
  def fb_login_enabled?
    fb_id.present?
  end
  
  #パスワード生成
  def self.generate_password
    password = ""
    #1,I,l,0,oを除く
    #chars = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    chars = ["A", "B", "C", "D", "E", "F", "G", "H",  "J", "K", "L", "M", "N",  "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k",  "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",   "2", "3", "4", "5", "6", "7", "8", "9"]
    8.times {
      password << chars[rand(chars.size)]
    }
    password
  end
  
end
