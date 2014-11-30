class AlbumsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :new, :update, :edit, :destroy]
  before_action :find_user
  before_action :find_album, only: [:show, :edit, :update, :destroy]
  before_action :ensure_proper_user, only: [:edit, :new, :create, :update, :destroy]
  before_action :add_breadcrumbs


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
    add_breadcrumb "Editing Album"
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

    def ensure_proper_user
      if current_user != @user
        flash[:error] = "You don't have permission to do that."
        redirect_to albums_path
      end
    end

    def add_breadcrumbs
      add_breadcrumb @user, profile_path(@user)
      add_breadcrumb "Albums", albums_path
    end

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
