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

1. [Install rbenv](https://github.com/rbenv/rbenv#installation).

2. [Install PostgreSQL](https://www.postgresql.org/download/).

## Okay, let's get rolling

1. Clone this repository and open the root directory:

        $ git clone git@github.com:nshki/playlocal-api.git
        $ cd playlocal-api

2. Ensure the right version of Ruby is installed:

        $ rbenv install

3. Install Bundler and project dependencies:

        $ gem install bundler
        $ bundle install

4. Create/load the database schema:

        $ bin/rails db:create
        $ bin/rails db:schema:load

5. Run tests and start the development server:

        $ bin/rails test
        $ bin/rails s -b 0.0.0.0 -p 3001
