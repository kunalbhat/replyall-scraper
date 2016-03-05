# Freddie Alerts
### Never miss out on a new Freddie again!

This utility scrapes [mailchimp.com/replyall](http://mailchimp.com/replyall/) at an interval and alerts me if a new Freddie is available. These free giveaways run out quickly, so time is of the essence.

![All Gone](https://dl.dropboxusercontent.com/u/7583033/github/all_gone.png)

> Dismayed to miss out on the Gold Freddie, I vowed to never let it happen again.

---

### What it does

Silly example aside, this app provides a loose template to create utilities for similar use cases:

- Scrape a page and get a value
- Compare that value against a stored value
- If it has changed, update the stored value
- Send an email to notify of the change

It was fun to use Nokogiri, Heroku Scheduler, and Mailgun for this exercise.

---

### How it works

##### Nokogiri

Parsing an HTML/XML document is easily done thanks to [Nokogiri](http://www.nokogiri.org/). After that, all the `divs` with class `freddie` are pulled into an array. The first one of those is the current Freddie.

```
doc = Nokogiri::HTML(open("http://www.mailchimp.com/replyall"))
@freddies = doc.css("div.freddie")

@active_freddie = @freddies.first['id']
```

The `id` of the element is then checked against an existing stored `id` in a database. If the new fetched `id` doesn't match the previous, we have a new Freddie!

```
if @active_freddie != old_freddie
  # Send notification
  # Update stored Freddie value
end
```

The caveat with scraping of course is that this is only reliable as long as the markup of the page being scraped isn't altered significantly.

-

##### Heroku Scheduler

[Heroku Scheduler](https://elements.heroku.com/addons/scheduler) runs the Rake task below every hour. If the app notices a new Freddie is available, an email notification will be sent.

```
task :default do
  desc "Scrape the page task run by Scheduler"
  get_freddie
end
```

-

##### Mailgun

[Mailgun](https://elements.heroku.com/addons/mailgun) sends the email notification when a new Freddie is detected.

![New Freddie](https://dl.dropboxusercontent.com/u/7583033/github/mailgun_notification.png)

---

### Configuration

Some environment variables are defined, locally in an `.env` file, and in the Heroku app's configuration for production:

```
DATABASE_URL=<value>
MAILGUN_API_KEY=<value>
MAILGUN_FROM=<value>
MAILGUN_FROM_NAME=<value>
MAILGUN_TO=<value>
MAILGUN_TO_NAME=<value>
```
