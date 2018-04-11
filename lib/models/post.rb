class Post < ContentfulModel::Base

  class << self
    def by_published_date
      order(:published_date, :desc)
    end

    def recent(options = {})
      posts = by_published_date
      posts = posts.reject { |p| p.id == options[:exclude].id } if options[:exclude]
      posts = posts.first(options[:limit]) if options[:limit]
      collection(posts)
    end
  end

  belongs_to :author
  belongs_to :category

  def read_time
    "#{(body.split.size.to_f / 184).ceil} min read"
  end

  def path
    "/#{published_date.year}/#{published_date.strftime('%m')}/#{published_date.strftime('%d')}/#{slug}/"
  end

end
