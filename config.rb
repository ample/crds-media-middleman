require 'dotenv/load'

# Activate and configure extensions
# https://middlemanapp.com/advanced/configuration/#configuring-extensions

activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end

activate :contentful do |f|
  f.space         = { contentful: '6xtqh9zzbhsk'}
  f.access_token  = ENV['CONTENTFUL_ACCESS_TOKEN']
  f.cda_query     = { limit: 1000 }
  f.content_types = { posts: 'post', categories: 'category', authors: 'authors' }
end

# Layouts
# https://middlemanapp.com/basics/layouts/

# Per-page layout changes
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# With alternative layout
# page '/path/to/file.html', layout: 'other_layout'

# Proxy pages
# https://middlemanapp.com/advanced/dynamic-pages/

data.contentful.posts.each do |_, post|
  date = post.published_date
  path = "/#{date.year}/#{date.strftime('%m')}/#{date.strftime('%d')}/#{post.slug}.html"
  proxy path, "/templates/post.html", locals: { post: post }, ignore: true
end

data.contentful.authors.each do |_, author|
  proxy "/authors/#{author.slug}.html", "/templates/author.html", locals: { author: author }, ignore: true
end

data.contentful.categories.each do |_, category|
  proxy "/topics/#{category.slug}.html", "/templates/category.html", locals: { category: category }, ignore: true
end

# proxy(
#   '/this-page-has-no-template.html',
#   '/template-file.html',
#   locals: {
#     which_fake_page: 'Rendering a fake page with a local variable'
#   },
# )

# Helpers
# Methods defined in the helpers block are available in templates
# https://middlemanapp.com/basics/helper-methods/

# helpers do
#   def some_helper
#     'Helping'
#   end
# end

# Build-specific configuration
# https://middlemanapp.com/advanced/configuration/#environment-specific-settings

# configure :build do
#   activate :minify_css
#   activate :minify_javascript
# end
