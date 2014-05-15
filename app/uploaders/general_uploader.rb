# encoding: utf-8

##モンキーパッチング
#module CarrierWave
#  class SanitizedFile
#    # Sanitize the filename, to prevent hacking
#    def sanitize(name)
#      name = name.gsub("\\", "/") # work-around for IE
#      name = File.basename(name)
#      #name = name.gsub(/[^a-zA-Z0-9\.\-\+_]/,"_")
#      name = name.force_encoding "utf-8"
#      name = "_#{name}" if name =~ /\A\.+\z/
#      name = "unnamed" if name.size == 0
#      return name.downcase
#    end
#  end
#  
#  module Uploader
#    module Cache
#      def original_filename=(filename)
#        #raise CarrierWave::InvalidParameter, "invalid filename" unless filename =~ /\A[a-z0-9\.\-\+_]+\z/i
#        #filename.force_encoding "utf-8"
#        @original_filename = filename
#      end
#      
#    end
#  end
#end



module CarrierWave
  class SanitizedFile
    # Sanitize the filename, to prevent hacking
    def sanitize(name)
      name = name.gsub("\\", "/") # work-around for IE
      name = File.basename(name)
      #name = name.gsub(/[^a-zA-Z0-9\.\-\+_]/,"_")
      name = name.force_encoding "utf-8"
      name = "_#{name}" if name =~ /\A\.+\z/
      name = name.gsub(/[\*\?\{\}\[\]<>\(\)~&\|\\\$;'`"\ ]/, "_")
      name = "unnamed" if name.size == 0
      return name.downcase
    end
  end
  
end


class GeneralUploader < CarrierWave::Uploader::Base


  # Include RMagick or ImageScience support:
  include CarrierWave::RMagick
  # include CarrierWave::ImageScience

  # Choose what kind of storage to use for this uploader:
  storage :file
  #storage :s3
  #storage :fog
  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  #def default_url
  #  "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  #end
  
  #イメージが空であるかどうかはobj.blank?で判断

  def default_url
    "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end

  #process :resize_to_fit => [800, 800]
#  process :scale => [800, 800]
#  
#  def scale(width,height)
#    #warn "scale呼ばれた:(#{width},#{height})"
#    #puts "cont=#{file.content_type}"
#    
#    #im_f = is_image?
#    #puts "イメージフラグ：#{im_f}"
#    if is_image?
#      resize_to_fit(width,height)
#    end
#  end

  version :limit do
    process :make_limit => [740, 500]
  end
  
  version :thumb do
    process :make_thmb => [200,200]
  end
  
  version :icon do
    process :make_icon => [32,32]
  end
  

  #
  #大きすぎる画像の制限
  #
  def make_limit(width,height)
    #warn "make_limitが呼ばれた"
    if is_image?
      #MAXを超えない場合はリサイズしない
      resize_to_limit(width,height)
    end
  end
  
  
  #
  #サムネイル
  #
  def make_thmb(width,height)
    #warn "make_thnmが呼ばれた"
    if is_image?
      #resize_to_fill(width,height) #←上下または左右が切り取られる
      #画像がサムネイルより小さい場合は拡大する
      resize_to_fit(width,height)
      
    end
  end
  
  #
  #アイコン
  #
  def make_icon(width,height)
    #warn "make_iconが呼ばれた"
    if is_image?
      resize_to_fill(width,height) #←上下または左右が切り取られる
      #resize_to_fit(width,height)
    end
  end
  
  #
  #
  #古いバージョンではURI_ENCODEされない
  if Gem::Version.create(CarrierWave::VERSION) < Gem::Version.create("0.9.0")
    def url
      #puts "urlがよばれた"
      URI.encode(super)
    end
  end
  
  #
  #オンデマンドの任意サイズ・サムネイル
  #ファイルが更新されたとき、同じファイル名だったら更新されない
  #縦横とも指定サイズより元画像のほうが小さい場合、
  #1.拡大しない
  #2.拡大する
  #指定サイズ枠と画像の間に余白ができる場合
  #1.隙間を埋めない
  #2.透明または白ピクセルで埋める
  def url_t(size, options = { })
    if self.blank?
      return self.url
    end
    
    width, height =  size.split('x').map{|s| s.to_i }
    target = current_path
    storedir = File.dirname(target)
    bname = File.basename(target)
    new_bname = "#{width}x#{height}_#{bname}"
    new_path = File.join(storedir, new_bname)
    new_file = clone
    new_file.retrieve_from_store!(new_bname)
    #warn "任意サイズのサムネイル作成:#{size}, target:#{target},#{File} fl#{file.class} self.class.storage=#{self.class.storage}"    
    unless new_file.file.exists? #File.exists?(new_path)
      if file.exists? #File.exists?(target)
        
  #warn "任意サイズのサムネイルがない:#{new_path}"
        options = { :pad => false, :stretch => true}.merge(options)
  #warn "dirty_resize(#{target}, #{new_path}, width, height, options)"
        with_temp_file(target, new_path) do |target, new_path|
          dirty_resize(target, new_path, width, height, options)
        end
      else
  #warn "作成元のファイルが存在しない"      
      end
    else
  #warn "任意サイズのサムネイルすでにあり"
    end
    return URI.encode(File.join(File.dirname(self.url), new_bname))
  end
  
  def with_temp_file(target, new_path)
    if self.class.storage == CarrierWave::Storage::Fog
#      retrieve_from_store!(File.basename(target))
#      tumb_uploader = clone
      
      Tempfile.open("original", :external_encoding => "BINARY"){|tempfile_orig|
        data = file.read
        warn "エンコーディング：#{data.encoding}"
        tempfile_orig.write data 
        Tempfile.open("new", :external_encoding => "BINARY"){|tempfile_new|
          def tempfile_new.original_filename
             @original_filename 
          end
          def tempfile_new.original_filename=(n)
             @original_filename = n
          end
          tempfile_new.original_filename = new_path
          
          yield tempfile_orig.path, tempfile_new.path
          
#          tumb_uploader.retrieve_from_store!(File.basename(new_path))
#          tumb_uploader.store!(tempfile_new)
          store!(tempfile_new)
          retrieve_from_store!(File.basename(target))
        }
      }
      
    else
      yield target, new_path
    end
  end

 def basename
   File.basename(current_path)
 end


  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  #def filename
  #  warn "origfilename =#{original_filename}"
  #   "something.jpg" if original_filename
  #end
  
    def sanitize(name)
   
      name = name.gsub("\\", "/") # work-around for IE
      name = File.basename(name)
      #name = name.gsub(/[^a-zA-Z0-9\.\-\+_]/,"_")
      name = name.force_encoding "utf-8"
      name = "_#{name}" if name =~ /\A\.+\z/
      name = "unnamed" if name.size == 0
      return name.downcase
    end
    
    def original_filename=(filename)
      #raise CarrierWave::InvalidParameter, "invalid filename" unless filename =~ /\A[a-z0-9\.\-\+_]+\z/i
      #filename.force_encoding "utf-8"
      @original_filename = filename
    end  
  
  private
  def is_image?
    #content_typeはファイルアップロード時にしかセットされない。file.content_typeはnilになる。
    "#{file.content_type}".split("/").first == "image"
#    if current_path.split(".").last == "xls"
#      return false
#    end
#    true
  end

  #
  #
  #
  def  dirty_resize(target, new_path, width, height, options)
    #warn "オプション#{options}"
    dirty_resize_limit(target, new_path, width, height, options){|img|
      if options[:pad]
        width, height = correct_zero_size(img, width, height)
        background=:transparent 
        gravity=::Magick::CenterGravity
        
        new_img = ::Magick::Image.new(width, height)
        if background == :transparent
          filled = new_img.matte_floodfill(1, 1)
        else
          filled = new_img.color_floodfill(1, 1, ::Magick::Pixel.from_color(background))
        end
        destroy_image(new_img)
        filled.composite!(img, gravity, ::Magick::OverCompositeOp)
        destroy_image(img)
        filled = yield(filled) if block_given?
        filled
      else
        img
      end
    }    
    
    
  end
  
  #
  #
  #
  def dirty_resize_limit(target, new_path, width, height, options)
    _manipulate(target, new_path) do |img|

       width, height = correct_zero_size(img, width, height)
      
      if options[:stretch]
        img.resize_to_fit!(width, height)
        img = yield(img) if block_given?
        img
      else
        geometry = Magick::Geometry.new(width, height, 0, 0, Magick::GreaterGeometry)
        new_img = img.change_geometry(geometry) do |new_width, new_height|
          img.resize(new_width, new_height)
        end
        destroy_image(img)
        new_img = yield(new_img) if block_given?
        new_img
      end
    end    
  end

  #
  #
  #
  def _manipulate(src_path, dest_path)
    
    options={}
    image = ::Magick::Image.read(src_path)
    
    frames = if image.size > 1
      list = ::Magick::ImageList.new
      image.each do |frame|
        list << yield( frame )
      end
      list
    else
      frame = image.first
      frame = yield( frame ) if block_given?
      frame
    end
    if options[:format]
      frames.write("#{options[:format]}:#{dest_path}")
    else
      frames.write(dest_path)
    end
    
    destroy_image(frames)
  rescue ::Magick::ImageMagickError => e
    raise CarrierWave::ProcessingError.new("Failed to manipulate with rmagick, maybe it is not an image? Original Error: #{e}")
  end
  
  #
  #
  #
  def correct_zero_size(img, width, height)
    if width == 0
      width = img.columns
    end
    
    if height == 0
      height = img.rows
    end
    
    [width, height]
    
  end


  after :store, :my_callback_store
  #↓削除のときのみ呼ばれる。更新のときは呼ばれない
  before :remove, :my_callback_remove
  


  #
  #
  #
  def my_callback_store(new_file)
    #warn "my_callbackが呼ばれた"
    begin
      sweep_ondemand_thumb_if_exists
    rescue => e
      p e
    end
  end
  
  #
  #
  #
  def my_callback_remove
    
    begin
      sweep_ondemand_thumb_if_exists
    rescue => e
      p e
    end 
  end
  
  
  #オンデマンドのサムネイルをクリアする
  #x.thumb.url_t("211x118")のように"thumb"をつけて呼び出すと
  #211x118thubm_xxx.jpgのようなファイルができてしまう
  #バージョンごとに呼ばないといけない
  def sweep_ondemand_thumb_if_exists
    #warn "削除スイープオンデマンド#{file.dir}"    
    
    target = current_path
    storedir = File.dirname(target)
    bname = File.basename(target)
    pat = /^\d+x\d+_#{Regexp.quote(bname)}$/
    #warn "検索パターン#{pat}"
    Dir.open(storedir).each{|f|
      next if f == "." || f== ".."
      #warn "チェック#{f}"
      if pat.match(f)
        #warn "オンデマンドのサムネイル削除：#{f}"
        File.unlink(File.join(storedir,f))
      end
    }
  end
  
  
end
