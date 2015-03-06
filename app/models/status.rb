class Status < ActiveRecord::Base
  
  belongs_to :user, dependent: :destroy

  attr_accessor :media_url

  validates :body, length: { in: 1..140, allow_nil: false, message: "must be between 1 and 140 characters"} 

  def generate_download_uri
    obj = Aws::S3::Object.new(bucket_name: ENV['S3_BUCKET'], key: self.media_key)
    self.media_url = obj.presigned_url(:get, expires_in: 3600)
  end

end
