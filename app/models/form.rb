#coding:utf-8
class Form < ActiveRecord::Base
  has_many :fields, :order => "sortkey,id", 
    :dependent => :destroy #紐付けされたフィールドも削除
    
  has_many :entries,     :dependent => :destroy #紐付けされたentryも削除
  
  has_many :form_permissions, :dependent => :destroy
  has_many :permitted_users, :through => :form_permissions, :source => :user  
  
  validates_presence_of :title , :template_name
  validates_uniqueness_of :template_name
  
  
  RESERVED_NAMES = ["admin", "entries","images","javascripts","stylesheets","uploads", "replies"]
  
  validate :_validate
  
  def _validate
    if errors.empty?
      if RESERVED_NAMES.include? template_name
        errors.add :base, "#{template_name}は予約されています"
      end
      
    end
    
  end
  
  
end
