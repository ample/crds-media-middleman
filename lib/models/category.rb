class Category < ContentfulModel::Base

  has_many :posts

  def path
    "/categories/#{slug}/"
  end

  def featured_image
    posts.select { |p| p.try(:featured_image).present? }.first.featured_image
  end

end
