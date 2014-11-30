class PicturesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :find_user
  before_action :find_album
  before_action :find_picture, only: [:edit, :update, :show, :destroy]
  before_action :add_breadcrumbs
  # before_action :set_picture, only: [:show, :edit, :update, :destroy]

  # respond_to :html

  def index
    @pictures = @album.pictures.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pictures }
    end
  end

  def show
    @picture = @album.pictures.find(params[:id])
    add_breadcrumb @picture, album_picture_path(@album, @picture)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @picture}
    end
  end

  def new
    @picture = Picture.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @picture}
    end
  end

  def edit
    @picture = Picture.find(params[:id])
  end

  def create
    @picture = @album.pictures.new(picture_params)
    @picture.user = current_user

    respond_to do |format|
      if @picture.save
        format.html { redirect_to album_pictures_path(@album), notice: 'Picture was successfully created' }
        format.json { render json: @picture, status: :created, location: @picture }
      else
        format.html { render action: "new" }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
       end
    end
  end

  def update
    @picture = Picture.find(params[:id])

    respond_to do |format|
      if @picture.update_attributes(picture_params)
        format.html { redirect_to album_pictures_path(@album), notice: 'Picture was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @picture = Picture.find(params[:id])
    @picture.destroy

    respond_to do |format|
      format.html { redirect_to album_pictures_url(@album) }
      format.json { head :no_content }
    end
  end

  def url_options
    { profile_name: params[:profile_name] }.merge(super)
  end

  private
    # def set_picture
      # @picture = Picture.find(params[:id])
    # end

    def add_breadcrumbs
      add_breadcrumb @user.first_name, profile_path(@user)
      add_breadcrumb "Albums", albums_path
      add_breadcrumb "Pictures", album_pictures_path(@album)
    end

    def find_user
      @user = User.find_by_profile_name(params[:profile_name])
    end

    def find_album
      if signed_in? && current_user.profile_name == params[:profile_name]
        @album = current_user.albums.find(params[:album_id])
      else
        @album = @user.albums.find(params[:album_id])
      end
    end

    def find_picture
      @picture = @album.pictures.find(params[:id])
    end

    def picture_params
      params.require(:picture).permit(:album_id, :user_id, :caption, :description, :asset)
    end
end
