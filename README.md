[![Build Status](https://travis-ci.org/Metaburn/dreams.svg?branch=master)](https://travis-ci.org/Metaburn/dreams)

# Metaburn Dreams

This is a platform to plan co-created events. It was originally created for Urban Burn Stockholm in 2016 and was then used for The Borderland in 2016 and For Midburnerot 2016 then Midburn 2017. It's being continuously and sporadically developed by a rag-tag team and will always be in beta. This version is set to be the mother of all versions.
You can see it in action here: 
* Midburn: http://dreams.midburn.org/?lang=en
* Midburnerot: http://dreams.midburnerot.com/?lang=en
* Borderland: http://dreams.theborderland.se/
* Urban Burn Stockholm: http://dreams.urbanburn.se/
* Art Jump: http://artjump.burningman.nl/

## To get started

* Install (version number indicated in `Gemfile`).
* Install postgres - `brew install postgresql`
* Install ImageMagick v6, for example [this way](https://stackoverflow.com/questions/42250292/rails-cant-install-rmagick-2-16-0-cant-find-magickwand-h#answer-43715913)
```
    rbenv local
    gem install bundler
    bundle install
    bundle exec rake db:migrate
```
To get all the deps and the database set up properly. To start the server:

    bundle exec rails s

Now rails will listen at `localhost:3000` for your requests.

Register a new user
http://localhost:3000/users/sign_up

Go to `dreams/new` to create a new dream and to `/dreams` to see a list of camps.

## There are tests

Run them with:

    bundle exec rspec spec

## Database

Currently sqlite is used as the local database. We will stick to this in development but set up
Postgres in production. Install sqlite with your favourite package manager and you should
be up and running right away.

## Production
If you're running the server locally you should those env variables:
* RACK_ENV=production
* RAILS_ENV=production

## Mail

In development mode [mailcatcher](http://mailcatcher.me/) is configured to catch emails
locally for easier testing.

## Active Admin
Users and creations can be administrated with Active Admin. 
After install, run:
```
bundle exec rake db:migrate db:seed
```
Then naviagte to `http://localhost:3000/admin`
and use `admin@example.com` and `password`

## Creating your first user
* Navigate to [http://localhost:3000/admin/tickets/new](http://localhost:3000/admin/tickets/new)
* Enter your phone number and email
* Then create your user with the same phone number and email here: [http://localhost:3000/users/sign_up](http://localhost:3000/users/sign_up)

## User types in the system
The system user types are: anonymous users, normal registered users, guides, admins

You can set yourself as a guide and admin in the /admin panel

Guide and admins see buttons on the dream page and info that normal and guests users dont have access to.
Guide and admins can close/open granting and edit dreams

## Ticket ID Import

Ticket ids are imported from a two column csv file of IDs which can be set to any url using `IMPORT_CSV_URL` env variable
Rake task is in lib/tasks/import.rake and is run with "bundle exec rake import"

## Ticket verifier through TixWise

We've added an optional verification through tixwise - you need to aquire an API from them and then set `TICKETS_EVENT_URL` ENV variable to a url such as:
```
https://www.tixwise.co.il/he/api.xml?USER=useremail@gmail.com&PASS=userpass&TOKEN=api_token&VERSION=1.0&ACTION=event_listPurchases&id=event_id
```
Make sure you change the username, password, token and event id

## Production

### Make sure all the env variables are set
On heroku use - https://github.com/xavdid/heroku-config

#### SAML integration

Place your IDP descriptor in `./vendor/saml/idpssodescriptor.xml` or provide an
alternative path in the `SAML_IDP_DESCRIPTOR` environment variable. 

Other environment variables:
  * `SAML_ENABLE=1` enable SAML and hide built-in registration
  * `SAML_CLIENT_ID` client id provided to the IdP
  * `SAML_HUMAN_NAME` name of IdP presented to user

### Creating initial database

From command line run

```
heroku run exec rake db:migrate db:seed --app <<APP_NAME>>
```

#### Puma
We are using puma for the webserver and usually use Heroku to deploy it
The default `WEB_CONCURRENCY=1` if you have ~1GB of mem we recommend on `WEB_CONCURRENCY=2`
though we did have some plans on using Dokku all of the repos right now are on heroku

#### Email
To get the mailing system working on Heroku -
* Add Sendgrid as a Resource (this will automatically set SENDGRID_USERNAME & SENDGRID_PASSWORD)
* Update the `EMAIL_FROM` using:
`heroku config:set EMAIL_FROM=metaburndreams@gmail.com`

#### Image upload
To set up the image upload make sure to create the S3 user and set the following heroku env variables
* `S3_BUCKET_NAME`
* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`

From our experience, if the s3 bucket didn't exist - it was automatically created on first time upload in case your user have write access to s3.

## Drive integration

#### Google apps script
We've added the ability to integrate to google drive.
on every new dream that is being created - a google apps script create a folder with the dream id, dream name, and give access to the dream owner. it also coppies some needed files to that folder and save the folder info and specific file ids to allow the user to edit them directly on google drive.

It require an google apps script published as API execution
and also the following env vars:
* `GOOGLE_APPS_SCRIPT`
* `GOOGLE_APPS_NAME`
* `GOOGLE_DRIVE_INTEGRATION=true`
* `GOOGLE_APPS_SCRIPT_FUNCTION='function-name'`
* `GOOGLE_CLIENT_SECRETS=content_of_client_secret.json`

1.Set the env `GOOGLE_DRIVE_INTEGRATION=true`
2.Start with enabling the API on the google console. getting a token.
Then set the `GOOGLE_CLIENT_SECRETS` variable
3.Then go to https://console.developers.google.com/apis/credentials?project=YOUR-PROJECT-ID
and copy the name of Oauth2 client Id - this will be the `GOOGLE_APPS_NAME` env variable
4.Then inside your script there is the actual function name to call it is usually `createDream` - this is the `GOOGLE_APPS_SCRIPT_FUNCTION` env
5.Finally leave the `GOOGLE_APPS_SCRIPT_TOKEN` empty. and then after you run your app for the first time. check the logs. you will see a url. this url will contain the actual token. then set the `GOOGLE_APPS_SCRIPT_TOKEN` to be that token

## Env Settings
You can copy .env-example to .env file and use it to check which ENV vars we are using

To install ENV vars in a quick way check out https://github.com/xavdid/heroku-config

#### Ability to Show/Edit Point of Contact
We've added the ability to show a contact person from art-department for the dream-creator in the dream page. This field is editable by admin/guide users only.

You will need to set the following env var:
* `SHOW_POINT_OF_CONTACT=true`

## Setting important dates
There is a feature that shows a notification to users - reminder of important dates.
You can alter `lockdown.yml` file with your important dates and then change in `en.xml` `dont_miss_out->actions->action_name`
It will be reminded to your users at the `Me` page. `View Dream` & `Edit Dream` page

## Ability to Show/Edit Safety File Comments
We've added the ability to show safety file comments for the dream-creator in the dream page. This field is editable by admin/guides only and it is visible to users on the show dream page - this could serve as a way to communicate with the artist outside of his email.

You will need to set the following env var:
* `SHOW_SAFETY_FILE_COMMENTS=true`

## FAQ
Q: How do I set multi language support
Set the `MULTI_LANG_SUPPORT` env variable to true on heroku
