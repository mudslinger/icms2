#coding:utf-8
class Library < ActiveRecord::Base
  
  attr_accessor :file
  
  belongs_to :created_by,  :class_name => "User"
  belongs_to :updated_by,  :class_name => "User"
  #belongs_to :user_up, :foreign_key => "updated_by", :class_name => "User"
  mount_uploader :file_path, GeneralUploader
  #validates_presence_of
 
  validates_presence_of :file_path, :message => ":ファイルを指定してください"
#validates_presence_of :label
  def image?
    libtype == "image"
  end


    
  
  def validate
    #return unless errors.empty?
    if file 
      self.content_type = file.content_type
      #@library.entry_id
      self.libtype = "#{self.content_type}".split("/").first == "image" ? "image" : "file"
      orig_filename =  file. original_filename
      orig_filename.force_encoding "UTF-8"
      self.file_name =orig_filename
      if self.label.blank?
        self.label = self.file_name
      end
      if self.description.blank?
        self.description = self.label 
      end
      self.file_name_ext = File.extname(orig_filename)
      #logger.debug "塩コーディング #{file. original_filename.encoding}"
    end    
  end

  #作成者名
  def created_by_name
    created_by ? created_by.name : ""
  end
  
  #更新者名
  def updated_by_name
    updated_by ? updated_by.name : ""
  end  
end
