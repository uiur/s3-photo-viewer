class ImagesController < ApplicationController
  def index
    s3 = Aws::S3::Resource.new
    bucket = s3.bucket(params[:bucket])
    @objs = bucket.objects(prefix: params[:prefix])
  end
end
