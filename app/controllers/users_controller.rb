class UsersController < ApplicationController
  def login
  end

  def profile
  end

  def dashboard
  end

  def calendar
  end

  def jobs
  end

  def post
  end

  def create_post
  end

  def initialize_tags
    tags = current_user[:skill].split(", ")
    saved_tags = current_user.saved_tags
    tags.each do |t|
      saved_tags[t] = { count: 1, weight: 1.0 }    # Add tag into history and initialize counter
    end
    current_user.update(saved_tags: saved_tags)
    render json: {errCode: 1}
  end

  def fill_tags
    user_tags = current_user[:saved_tags]
    render json: {errCode: 1}
  end

  def reset_tags
  end
end
