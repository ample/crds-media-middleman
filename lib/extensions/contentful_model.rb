require 'pry'
require 'yaml'

# ---------------------------------------- | Sapwood Model Extension

class ContentfulModel < Middleman::Extension

  def initialize(app, options_hash = {}, &block)
    super
    load_models!
  end

  private

  def load_models!
    path = File.join(::Middleman::Application.root, 'lib', 'models', '*.rb')
    Dir.glob(path).each do |f|
      filename = File.basename(f)
      basename = filename.chomp(File.extname(f))
      require_relative("../models/#{filename}")
      basename.classify.constantize.raw_data = app.data.contentful.send(basename.pluralize.to_sym).to_a
    end
  end

end

# ---------------------------------------- | Sapwood Model Base

class ContentfulModel::Base

  class << self
    attr_accessor :raw_data

    def collection(objects)
      ContentfulModel::Collection.new(objects)
    end

    def all
      collection(raw_data.map { |data| new(data) })
    end

    def order(attr, direction = :asc)
      all.order(attr, direction)
    end

    def limit(count)
      all.limit(count)
    end

    def belongs_to(attr)
      define_method(attr.to_sym) do
        attr.to_s.classify.constantize.new(data.send(attr.to_sym))
      end
    end

    def has_many(attr)
      define_method(attr.to_sym) do
        objects = attr.to_s.singularize.classify.constantize.all.select do |obj|
          obj.send(self.class.to_s.downcase).id == id
        end
        ContentfulModel::Collection.new(objects)
      end
    end
  end


  attr_reader :data

  def initialize(data = {})
    @data = data.is_a?(Array) ? data.last : data
  end

  def method_missing(method_name, *args, &block)
    return super unless data.keys.map(&:to_s).include?(method_name.to_s)
    data.send(method_name.to_sym)
  end

  def respond_to_missing?(method_name, include_private = false)
    data.keys.map(&:to_s).include?(method_name.to_s)
  end

end

  # ---------------------------------------- | Sapwood Model Collection

class ContentfulModel::Collection < Array

  def order(attr, direction = :asc)
    collection = sort_by { |item| item.send(attr.to_sym) }
    ContentfulModel::Collection.new(direction.to_sym == :asc ? collection : collection.reverse)
  end

  def limit(count)
    ContentfulModel::Collection.new(first(count))
  end

end
