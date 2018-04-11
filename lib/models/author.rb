class Author < ContentfulModel::Base

  has_many :posts

  def last_name
    name.split.last
  end

  def path
    "/authors/#{slug}/"
  end

end
