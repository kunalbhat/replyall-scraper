require 'bundler'
require 'open-uri'

Bundler.require

require_relative 'config/mailgun'
require_relative 'config/datamapper'
require_relative 'models/post'

# Just do nothing if someone hits the app's URL
get '/' do
end

def send_notification
  @mg_client.send_message "#{ENV['MAILGUN_FROM'].split('@')[1]}", @message_params
end

def update_freddie(new_freddie)
  post_to_update = Post.last
  post_to_update.update(:title => new_freddie)
end

def get_freddie
  doc = Nokogiri::HTML(open("http://www.mailchimp.com/replyall"))

  @freddies       = doc.css("div.freddie")
  @active_freddie = @freddies.first['id']

  if @active_freddie != old_freddie
    send_notification # Send notification through Mailgun
    update_freddie(@active_freddie)
  else
    p "No new Freddie yet"
  end
end

def old_freddie
  @freddie = Post.last

  return @freddie['title']
end
