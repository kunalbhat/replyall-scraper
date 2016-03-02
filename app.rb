require 'open-uri'
require 'nokogiri'
require 'data_mapper'
require 'dm-sqlite-adapter'
require 'dm-migrations'

DataMapper.setup(:default, "sqlite3://#{File.expand_path(File.dirname(__FILE__))}/db/db.sqlite")

class Post
  include DataMapper::Resource

  property :id,    Serial
  property :title, String
  property :created_at, DateTime
end

def update_freddie(new_freddie)
  DataMapper.auto_upgrade!
  DataMapper.finalize

  post_to_update = Post.last
  post_to_update.update(:title => new_freddie)
end

def get_freddie
  doc = Nokogiri::HTML(open("http://www.mailchimp.com/replyall"))

  @freddies       = doc.css("div.freddie")
  @active_freddie = @freddies.first['id']

  if @active_freddie != get_old_freddie
    # Send notification e.g. "New Freddie!"
    update_freddie(@active_freddie)
  end
end

def get_old_freddie
  @freddie = Post.last

  return @freddie['title']
end

get_freddie
