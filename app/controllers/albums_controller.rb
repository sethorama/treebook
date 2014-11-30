class AlbumsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :new, :update, :edit, :destroy]
  before_action :find_user
  before_action :find_album, only: [:show, :edit, :update, :destroy]


  respond_to :html

  def index
    @albums = @user.albums.to_a
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @albums }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @album }
    end
  end

  def new
    @album = current_user.albums.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @album }
    end
  end

  def edit
  end

  def create
    @album = current_user.albums.new(album_params)
    respond_to do |format|
      if @album.save
        format.html { redirect_to @album, notice: 'Album was successfully created.' }
        format.json { render json: @album, status: :created, location: @album }
      else
        format.html { render action: "new" }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @album.update(album_params)
    respond_with(@album)
  end

  def destroy
    @album.destroy
    respond_with(@album)
  end

  def url_options
    { profile_name: params[:profile_name] }.merge(super)
  end

  private
    def find_user
      @user = User.find_by_profile_name(params[:profile_name])
    end

    def find_album
      @album = current_user.albums.find(params[:id])
    end

    def album_params
      params.require(:album).permit(:user_id, :title)
    end
end
