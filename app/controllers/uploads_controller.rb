class UploadsController < ApplicationController
  def new
  end

  def create
    # Make object in bucket for the upload
    obj = S3_BUCKET.objects[params[:file].original_filename]

    # Upload the file
    obj.write(
      file: params[:file],
      acl: :bucket_owner_full_control
    )

    # Create an object for the upload
    @upload = Upload.new(
    		url: obj.public_url,
		    name: obj.key
    	)

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
end
