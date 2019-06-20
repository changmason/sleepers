# Sleepers API Server

## The endpoints

This project implements the following HTTP JSON API endpoints, with authentication scheme by matching the API-KEY with its corrosponding user in the database as the current_user.

| Method | Path                       | Description
| ------ | -------------------------- | ---------------------------------------
| PUT    | `/api/sleeps/:uuid`        | Create or update a sleep record
| GET    | `/api/sleeps`              | Get all sleep records
| POST   | `/api/followings`          | Follow a friend
| DELETE | `/api/followings/:id`      | Unfollow a friend
| GET    | `/api/friends/:id/sleeps`  | Get past-week sleep records of a friend

For more detailed usage of the API endpoints, please use the interactive Swagger UI to explore http://localhost:3000/api-docs/index.html

## To start up

Make sure you have `ruby 2.5.1p57` and PostgreSQL installed on your system. If you don't please update `Gemfile` and `config/database.yml` based on your configurations.

1. Clone and `cd` to the project
2. Run `bundle install` to install dependencies
3. Run `rails db:create` to create the database
4. Run `rails db:migrate` to create the tables
5. Run `rails db:seed` to create example seed data
6. Run `rails server` to start the development server
