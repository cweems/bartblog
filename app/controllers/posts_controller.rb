#app/controllers/posts_controller.rb

class PostsController < ApplicationController
  before_action :find_post, only: [:edit, :update, :show, :delete]
  before_action :authenticate_user!

  # Index action to render all posts
  def index
    @posts = current_user.posts
    @grouped_posts = {}


    @posts.each do |post|
      if @grouped_posts[post.title]
        @grouped_posts[post.title] << post
      else
        @grouped_posts[post.title] = [post]
      end
    end

    @posts_count = current_user.posts.count
    @cars_ridden = @grouped_posts.keys.count
    @matched_cars = 0

    @grouped_posts.each do |key, value|
      if value.length > 1
        @matched_cars += 1
      end
    end
  end

  # New action for creating post
  def new
    @post = Post.new
  end

  # Create action saves the post into database
  def create
    post = Post.new(
      title: post_params['title'],
      car_end: post_params['car_end'],
      body: post_params['body'],
      users_id: current_user.id)
    if post.valid?
      if (current_user.posts.find_by_title(post_params['title']))
        flash[:notice] = "Match! You've been on this car before."
      end
      post.save!
      redirect_to post_path(post)
    else
      flash[:alert] = "Error creating new post!"
      render :new
    end
  end

  # Edit action retrives the post and renders the edit page
  def edit
  end

  # Update action updates the post with the new information
  def update
    if @post.update_attributes(post_params)
      flash[:notice] = "Successfully updated post!"
      redirect_to post_path(@post)
    else
      flash[:alert] = "Error updating post!"
      render :edit
    end
  end

  # The show action renders the individual post after retrieving the the id
  def show
    @post = Post.find(params[:id])
    @related_posts = []
    current_user.posts.where(title: @post.title).each do |p|
      if p.id != @post.id
        @related_posts << p
      end
    end
  end

  # The destroy action removes the post permanently from the database
  def destroy
    if @post.destroy
      flash[:notice] = "Successfully deleted post!"
      redirect_to posts_path
    else
      flash[:alert] = "Error updating post!"
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :car_end, :body, :utf8, :authenticity_token, :commit, :user_id)
  end

  def find_post
    @post = Post.find(params[:id])
  end
end
