class UploadsController < ApplicationController
  def new
  end

  def create
    # Make object in bucket for the upload
    obj = S3_BUCKET.objects[params[:file].original_filename]

    # Upload the file
    obj.write(file: params[:file], acl: :public_read)

    # Create an object for the upload
    @upload = Upload.new(url: obj.public_url, name: obj.key)

    # Save the upload
    if @upload.save
      redirect_to uploads_path, success: 'File successfully uploaded'
    else
      flash.now[:notice] = 'There was an error'
      render :new
    end
  end

  def index
    @uploads = Upload.all
  end

  def destroy
    @upload = Upload.find_by_name(params[:key]).destroy
    delete = S3_BUCKET.objects.delete(params[:key])
    redirect_to :action => 'index'
  end

end
