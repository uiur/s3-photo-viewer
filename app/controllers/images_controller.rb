class ImagesController < ApplicationController
  DEFAULT_SIZE = 10

  def index
    s3 = Aws::S3::Resource.new
    bucket = s3.bucket(params[:bucket])

    @objs = bucket.objects(prefix: params[:prefix])

    if params[:order] == 'desc'
      @objs = @objs.reverse_each
    end

    @objs = @objs.first(params[:size].to_i || DEFAULT_SIZE)
  end
end
