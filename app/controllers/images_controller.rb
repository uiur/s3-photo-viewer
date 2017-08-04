class ImagesController < ApplicationController
  DEFAULT_SIZE = 10

  def index
    s3 = Aws::S3::Resource.new
    bucket = s3.bucket(params[:bucket])

    @objs = bucket.objects(prefix: params[:prefix])

    if params[:order] == 'desc'
      @objs = @objs.reverse_each
    end

    page = params[:page]&.to_i || 1
    size = params[:size]&.to_i || DEFAULT_SIZE

    @objs = @objs.select { |obj| is_image?(obj.key) }.drop((page - 1) * size).first(size)
  end

  private

  def is_image?(key)
    key =~ /\.png|jpg|jpeg|gif$/i
  end
end
