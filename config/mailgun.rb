email_subject = "NEW FREDDIE AVAILABLE!!!"
email_body    = "Go get it at mailchimp.com/replyall"

@mg_client = Mailgun::Client.new "#{ENV['MAILGUN_API_KEY_SANDBOX']}"

@message_params = {:from   => "#{ENV['MAILGUN_FROM_NAME']} <#{ENV['MAILGUN_FROM']}>",
                  :to      => "#{ENV['MAILGUN_TO_NAME']} <#{ENV['MAILGUN_TO']}>",
                  :subject => "#{email_subject}",
                  :text    => "#{email_body}"}
