require 'bundler'
require 'open-uri'

Bundler.require

require_relative 'config/datamapper'
require_relative 'models/post'

def send_notification
  mg_client = Mailgun::Client.new "#{ENV['MAILGUN_API_KEY_SANDBOX']}"

  message_params = {:from    => "Mailgun Sandbox <#{ENV['MAILGUN_FROM']}>",
                    :to      => "Kunal Bhat <#{ENV['MAILGUN_TO']}>",
                    :subject => 'NEW FREDDIE AVAILABLE!!!',
                    :text    => 'Go get it at mailchimp.com/replyall !!!'}

  mg_client.send_message "#{ENV['MAILGUN_FROM'].split('@')[1]}", message_params
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
    # Send notification e.g. "New Freddie!"
    update_freddie(@active_freddie)
  end
end

def old_freddie
  @freddie = Post.last

  return @freddie['title']
end

get_freddie
