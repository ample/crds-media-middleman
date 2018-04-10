require 'dotenv/load'

# ---------------------------------------- | Extensions

activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end

activate :contentful do |f|
  f.space         = { contentful: '6xtqh9zzbhsk'}
  f.access_token  = ENV['CONTENTFUL_ACCESS_TOKEN']
  f.cda_query     = { limit: 1000 }
  f.content_types = { posts: 'post', categories: 'category', authors: 'authors' }
end

# ---------------------------------------- | Layouts

page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# ---------------------------------------- | Dynamic Pages

data.contentful.posts.each do |_, post|
  date = post.published_date
  path = "/#{date.year}/#{date.strftime('%m')}/#{date.strftime('%d')}/#{post.slug}/index.html"
  proxy path, "/templates/post.html", locals: { post: post }, ignore: true
end

data.contentful.authors.each do |_, author|
  proxy "/authors/#{author.slug}/index.html", "/templates/author.html", locals: { author: author }, ignore: true
end

data.contentful.categories.each do |_, category|
  proxy "/categories/#{category.slug}/index.html", "/templates/category.html", locals: { category: category }, ignore: true
end

# ---------------------------------------- | Helpers

helpers do

  def post_path(post)
    date = post.published_date
    "/#{date.year}/#{date.strftime('%m')}/#{date.strftime('%d')}/#{post.slug}/"
  end

  def author_path(author)
    "/authors/#{author.slug}/"
  end

  def category_path(category)
    "/categories/#{category.slug}/"
  end

  def markdown(text)
    Kramdown::Document.new(text).to_html
  end

end

# ---------------------------------------- | Build Settings

# configure :build do
#   activate :minify_css
#   activate :minify_javascript
# end
