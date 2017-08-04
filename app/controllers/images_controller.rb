class ImagesController < ApplicationController
  DEFAULT_SIZE = 10

  def index
    s3 = Aws::S3::Resource.new
    bucket = s3.bucket(params[:bucket])

    @objs =
      bucket
        .objects(prefix: params[:prefix])
        .reverse_each
        .first(params[:size].to_i || DEFAULT_SIZE)
  end
end
