#!/usr/bin/env ruby

require 'date'
require 'json'
require 'yaml'
require 'nokogiri'
require 'ostruct'

class PostList
  attr_reader :posts
  def initialize
    @posts = Array.new
  end

  def to_json
    self.posts.reduce(Array.new) do |data, post|
      data << {title: post.title, slug: post.slug}
    end.to_json
  end

  private
  def method_missing(method, *args, &block)
    @posts.send(method, *args, &block)
  end
end

class Post
  attr_accessor :metadata
  def initialize(slug, date, metadata)
    @metadata = OpenStruct.new(metadata.merge(slug: slug, date: date))
  end

  def document
    Nokogiri::HTML(self.body)
  end

  def to_json
    @metadata.instance_variable_get(:@table).to_json
  end

  alias_method :inspect, :to_json

  private
  def method_missing(method, *args, &block)
    @metadata.send(method, *args, &block)
  end
end

# Parse the posts.
posts = Dir.glob('posts/*.html').reduce(PostList.new) do |posts, path|
  match = path.split('/').last.match(/^(\d{4}-\d{2}-\d{2})-(.+)\.html$/)
  date = Date.parse(match[1]); slug = match[2]

  post = Post.new(slug, date, YAML.load_file(path))
  post.body = File.read(path).match(/\n---\n(.+)$/m)[1].strip

  post.excerpt = post.document.css('#excerpt').inner_html.strip

  puts "~ Parsing #{post.inspect}"

  posts.push(post)
end

# Generate all the files.
Dir.chdir(File.expand_path('../content', __FILE__))
system("mkdir -p api/posts api/tags 2> /dev/null")

posts.each do |post|
  File.open("api/posts/#{post.slug}.json", 'w') do |file|
    file.puts(post.to_json)
  end
end

tags = posts.reduce(Hash.new) do |tags, post|
  post.tags.each do |tag|
    tags[tag] ||= PostList.new
    tags[tag] << post
  end

  tags
end

tags.each do |tag, posts|
  File.open("api/tags/#{tag}.json", 'w') do |file|
    file.puts(posts.to_json)
  end
end
