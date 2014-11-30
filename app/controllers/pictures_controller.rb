class PicturesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :find_user
  before_action :find_album
  # before_action :set_picture, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @pictures = Picture.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pictures }
    end
  end

  def show
    @picture = Picture.find(params[:id])
  end

  def new
    @picture = Picture.new
    respond_with(@picture)
  end

  def edit
  end

  def create
    @picture = Picture.new(picture_params)
    @picture.save
    respond_with(@picture)
  end

  def update
    @picture.update(picture_params)
    respond_with(@picture)
  end

  def destroy
    @picture.destroy
    respond_with(@picture)
  end

  def url_options
    { profile_name: params[:profile_name] }.merge(super)
  end

  private
    # def set_picture
      # @picture = Picture.find(params[:id])
    # end

    def find_user
      @user = User.find_by_profile_name(params[:profile_name])
    end

    def find_album
      if signed_in?
        @album = current_user.albums.find(params[:album_id])
      else
        @album = @user.albums.find(params[:album_id])
      end
    end

    def find_picture
      @picture = @album.pictures.find(params[:picture_id])
    end

    def picture_params
      params.require(:picture).permit(:album_id, :user_id, :caption, :description)
    end
end
