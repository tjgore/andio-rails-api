## Andio - React App with Rails Api (*still in development*)

Andio is an aid platform that connects people in need to willing volunteers in your neighborhood

This repo is the Rails api [https://andio.herokuapp.com](https://andio.herokuapp.com) for the react app [https://andio-react.surge.sh](https://andio-react.surge.sh)

You can find the react repo here [https://github.com/tjgore/andio-react](https://github.com/tjgore/andio-react)

#### Backend
* Docker (optional)
* Rails 5.2.0
* Rails active storage
* Ruby 2.5.1
* jwt
* Database: sqlite3 (for dev), postgres (for prod)
* Deployed on Heroku

### Installation locally

- *(Optional)* Download and install docker
 
- Clone repo to your system

#### Rails setup

- Pull rubyonrails docker image or create your own ruby on rails docker container.
  
  `$ docker pull tjwesleygore/rubyonrails:1.1`

- Run docker image and start the container.

  ```
  $ docker run -it --rm --name andio -p 3001:3000 -v /path/to/repo/railsapi/folder:/usr/src/my-app tjwesleygore/rubyonrails:1.1
  ```

- Start up rails.
  
  ```
  #In your docker container

  $ cd /usr/src/my-app
  $ bundle install
  $ EDITOR="nano --wait" rails credentials:edit
  $ rails active_storage:install
  $ rails db:migrate
  $ rails s
  ```
- Run all rails test

  ```
  $ rails test test/
  ```
 
 Change CORS origin domain in /config/initializers/cors.rb to your own domain


#### Deploy to Heroku 

```
$ heroku login

$ heroku create <app-name>

// optional 
$ heroku builpacks:set heroku/ruby

$ git push heroku master 

```