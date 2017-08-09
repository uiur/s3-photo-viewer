class ImagesController < ApplicationController
  DEFAULT_SIZE = 10

  def index
    params[:prefix] ||= ''

    s3 = Aws::S3::Resource.new
    bucket = s3.bucket(params[:bucket])

    client = Aws::S3::Client.new
    res = client.list_objects(bucket: params[:bucket], delimiter: '/', prefix: params[:prefix] + '/')

    @objs = []
    @dirs= []

    if res.common_prefixes.present?
      @dirs = res.common_prefixes.map(&:prefix)
      return
    end

    @objs = bucket.objects(prefix: params[:prefix])

    if params[:order] == 'desc'
      @objs = @objs.reverse_each
    end

    @objs = @objs.select { |obj| is_image?(obj.key) }

    step = params[:step]&.to_i || 1
    @objs = @objs.select.with_index {|obj, i| i % step == 0 }

    page = params[:page]&.to_i || 1
    size = params[:size]&.to_i || DEFAULT_SIZE
    @objs = Kaminari.paginate_array(@objs).page(page).per(size)
  end

  private

  def is_image?(key)
    key =~ /\.png|jpg|jpeg|gif$/i
  end
end
