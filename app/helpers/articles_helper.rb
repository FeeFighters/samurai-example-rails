module ArticlesHelper

  def purchased?(article)
    article.users.include?(current_user)
  end
    
end
