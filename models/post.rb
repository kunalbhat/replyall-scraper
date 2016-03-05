class Post
  include DataMapper::Resource

  property :id,    Serial
  property :title, String
  property :created_at, DateTime

  DataMapper.finalize
  DataMapper.auto_upgrade!
end
