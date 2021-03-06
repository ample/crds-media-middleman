require 'dotenv/load'
require 'active_support/core_ext/array'
require 'lib/middleman_extensions'

POSTS_PER_PAGE = 16

# ---------------------------------------- | Extensions

activate :contentful_model

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

Post.by_published_date.each do |post|
  date = post.published_date
  path = "/#{date.year}/#{date.strftime('%m')}/#{date.strftime('%d')}/#{post.slug}/index.html"
  proxy path, "/templates/post.html", locals: { post: post }, ignore: true
end

Post.by_published_date.in_groups_of(POSTS_PER_PAGE).each_with_index do |posts, idx|
  proxy "/page/#{idx + 1}/index.html", "/templates/posts_page.html", locals: { page_num: idx + 1, posts: posts }, ignore: true
end

Author.all.each do |author|
  proxy "/authors/#{author.slug}/index.html", "/templates/author.html", locals: { author: author }, ignore: true
end

Category.all.each do |category|
  proxy "/categories/#{category.slug}/index.html", "/templates/category.html", locals: { category: category }, ignore: true
end

# ---------------------------------------- | Helpers

helpers do

  # --- Routes ---

  def post_page_path(page_num)
    "/page/#{page_num}/"
  end

  # --- Rendering ---

  def markdown(text)
    Kramdown::Document.new(text).to_html
  end

  # --- Pagination ---

  def posts_per_page
    POSTS_PER_PAGE
  end

  def pagination_links(current_page = 1)
    total_posts = data.contentful.posts.size
    total_pages = (total_posts.to_f / POSTS_PER_PAGE).ceil
    return unless total_pages > 1
    page_nums = (current_page - 2 .. current_page + 2).to_a.reject { |i| i <= 0 || i > total_pages }
    partial 'partials/pagination', locals: {
      current_page: current_page,
      page_nums: page_nums,
      prev_link: current_page > 1,
      next_link: current_page < total_pages
    }
  end

  # --- Meta ---

  def page_title
    return current_page.metadata[:locals][:title] if current_page.metadata[:locals][:title]
    return current_page.data.title if current_page.data.title
    data.settings.title
  end

end

# ---------------------------------------- | Build Settings

# configure :build do
#   activate :minify_css
#   activate :minify_javascript
# end
