# Find Freddie
### Never miss out on a new Freddie again!

This utility scrapes [mailchimp.com/replyall](http://mailchimp.com/replyall/) at an interval and alerts me if a new Freddie is available. These free giveaways run out quickly, so time is of the essence.

![All Gone](https://dl.dropboxusercontent.com/u/7583033/github/all_gone.png)

> Dismayed to miss out on the Gold Freddie, I vowed to never let it happen again.

### How it works

##### Nokogiri

Parsing an HTML/XML document is very easey with [Nokogiri](http://www.nokogiri.org/). After that, all the `divs` with class `freddie` are pulled into an array. The first one of those is the current Freddie.

```
doc = Nokogiri::HTML(open("http://www.mailchimp.com/replyall"))
@freddies = doc.css("div.freddie")
```

The `id` of the element is then checked against an existing stored `id` in a database. If the new fetched `id` doesn't match the previous, we have a new Freddie!

```
if @active_freddie != old_freddie
  # Send notification
  # Update stored Freddie value
end
```

##### Heroku Scheduler

[Heroku Scheduler](https://elements.heroku.com/addons/scheduler) runs the script that checks the page every hour. If anything has changed, the app will send a notification.

##### SendGrid

[SendGrid](https://elements.heroku.com/addons/sendgrid) sends the email notification!
