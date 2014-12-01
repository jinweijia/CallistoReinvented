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
      saved_tags[t] = { count: 1, weight: 2.0 }
    end
    current_user.update(saved_tags: saved_tags)
    render template: "profile/index"
  end

  def fill_tags
    user_tags = current_user[:saved_tags]
    similar_tags_matrix = []
    similarity_matrix   = []
    tags_to_estimate    = []
    threshold           = 0.1 # threshold for cosine similarity, can be fine-tuned to increase performance
    minimum_tag_overlap = user_tags.length/2
    User.all.each do |u|
      if u[:email] != current_user[:email]
        alikeness_matrix = []
        user_tags.each do |tag|
          if u[:saved_tags].member?(tag[0])
            alikeness_matrix.append([u[:saved_tags][tag[0]][:weight], user_tags[tag[0]][:weight]])
          end
          if alikeness_matrix.length > minimum_tag_overlap
            dot_product   = 0.0
            len_squared_1 = 0.0
            len_squared_2 = 0.0
            alikeness_matrix.each do |am|
              dot_product   += am[0] * am[1]
              len_squared_1 += am[0] * am[0]
              len_squared_2 += am[1] * am[1]
            end
            cos_similarity = Math.acos(dot_product/Math.sqrt(len_squared_1)/Math.sqrt(len_squared_2))
            if cos_similarity < threshold
              similar_tags_matrix.append(u[:saved_tags])
              similarity_matrix.append(cos_similarity)
            end
          end
        end
        u[:saved_tags].each do |tag|
          if !user_tags.member?(tag[0])
            tags_to_estimate.append(tag[0])
          end
        end
      end
    end
    tags_to_estimate.each do |tte|
      top = 0.0
      bot = 0.0
      for i in 0..(similarity_matrix.length-1)
        tags       = similar_tags_matrix[i]
        similarity = similarity_matrix[i]
        if tags.member?(tte)
          top += (threshold - similarity) * tags[tte][:weight]
          bot += (threshold - similarity)
        end
      end
      if bot != 0.0
        user_tags[tte] = { count: 1, weight: top/bot }
      end
    end
    current_user.update(saved_tags: user_tags)
    render json: {errCode: 1}
  end

  def reset_tags
  end
end
