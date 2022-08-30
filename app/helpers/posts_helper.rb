module PostsHelper
  def creator_name post
    post.user == current_user ? "You" : post.user.name
  end
end
