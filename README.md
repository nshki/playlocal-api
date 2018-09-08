Play Local (API)
================

The API for a web app that enables gamers to discover local opponents.


# Client

This app is separate from the client app, which can be found [here](https://github.com/nshki/playlocal-client).
All information about what this project is, contributing guidelines, and code of
conduct can all be found in the client app repository.


# Technologies

- [Ruby on Rails](https://rubyonrails.org/)
- [PostgreSQL](https://www.postgresql.org/)
- [GraphQL](https://github.com/rmosolgo/graphql-ruby)
- [OmniAuth](https://github.com/omniauth/omniauth)
- [JWT](https://github.com/jwt/ruby-jwt)


# Getting Started

## Some prerequisites

1. [Install rbenv](https://github.com/rbenv/rbenv#installation). Make sure you
   also install rbenv-build (also in their instructions).

2. [Install PostgreSQL](https://www.postgresql.org/download/).

3. Get [Twitter access tokens](https://developer.twitter.com/en/docs/basics/authentication/guides/access-tokens.html)
   for local development. Add `http://localhost:3001/auth/twitter/callback` to
   Callback URLs.

4. Get a [Discord access tokens](https://discordapp.com/developers/applications/#top)
   for local development. Add `https://localhost:3001/auth/discord/callback` to
   Redirects under the OAuth2 menu item.

## Okay, let's get rolling

1. Clone this repository and open the root directory:

        $ git clone git@github.com:nshki/playlocal-api.git
        $ cd playlocal-api

2. Ensure the right version of Ruby is installed:

        $ rbenv install

3. Install Bundler and project dependencies:

        $ gem install bundler
        $ bundle install

4. Create a file called `.env` with the following contents:

        AUTH_SECRET=<Generate with `bin/rails secret`>
        TWITTER_API_KEY=<YOUR TWITTER ACCESS TOKEN HERE>
        TWITTER_API_SECRET=<YOUR TWITTER SECRET TOKEN HERE>
        DISCORD_API_KEY=<YOUR DISCORD ACCESS TOKEN HERE>
        DISCORD_API_SECRET=<YOUR DISCORD SECRET TOKEN HERE>
        CLIENT_URL=http://localhost:3000
        CLIENT_ORIGIN=localhost:3000

5. Create/load the database schema:

        $ bin/rails db:create
        $ bin/rails db:schema:load

6. Run tests and start the development server:

        $ bin/rails test
        $ bin/rails s -b 0.0.0.0 -p 3001
