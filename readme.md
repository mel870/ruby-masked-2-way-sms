### This is a Ruby on Rails Example

## Prerequisites

- You have a Bandwidth account
- You have at least one Bandwidth Phone Number allocated to your account

Tutorial for buying and allocating a phone number

http://ap.bandwidth.com/docs/how-to-guides/buying-new-phone-numbers/

## Getting Started & Installing on Heroku

Clone and create a new heroku app

```
$ git clone https://github.com/bandwidthcom/ruby-bandwidth-example.git
$ cd ruby-bandwidth-example/anon-two-way-sms
$ bundle
$ git init
$ git add -A
$ git commit -m "init"
$ heroku create
$ git push heroku master
$ heroku config:set BW_USER_ID='u-your_user_id_found_in_account_tab'
$ heroku config:set BW_TOKEN='t-your_token_found_in_account_tab'
$ heroku config:set BW_SECRET='your_secret_found_in_account_tab'
$ heroku run rake db:migrate
```

## Update Your Bandwidth Account For Incoming SMS

Login to your Bandwidth account and set-up an application and add your phone number for your phone number to send inbound text messages to heroku

Messaging URL: https://your-heroku-app.herokuapp.com/messages

http://ap.bandwidth.com/docs/how-to-guides/configuring-apps-incoming-messages-calls/

Open Heroku and Set-Up Your Phone Number
```
$ heroku open
```

Set the Bw phone number = the phone number you configured above
Set the agent phone number to your own mobile phone where you want to recieve messages

