CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',                        # 必須
    :aws_access_key_id      => 'LERHNKLSJLEJRFER934EJ',                        # 必須
    :aws_secret_access_key  => 'fjalLKLDF123412342121LLLkekke',                        # 必須
    :region                 => 'ap-northeast-1',                  #リージョン optional, defaults to 'us-east-1'
    #:host                   => 's3.example.com',             # optional, defaults to nil
    #:endpoint               => 'https://s3.example.com:8080' # optional, defaults to nil
  }
  config.fog_directory  = 'mybaakkeet'                     #バケット名 必須
  #config.fog_public     = false                                   # optional, defaults to true
  #config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end
