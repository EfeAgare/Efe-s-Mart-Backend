# Back End

- Add test cases for the main functions of the system.
- Use Dockerfile to the root of the project to run the app in docker environment

## Getting started

### Prerequisites

In order to install and run this project locally, you would need to have the following installed on you local machine.

- [**Ruby 2.6.1**](https://nodejs.org/en/)
- [**MySQL**](https://www.mysql.com/downloads/)
- [**Bundle gem**](https://https://bundler.io/)

### Installation

- Clone this repository

- Navigate to the project directory

- Run `bundle install` to instal the projects dependencies
- Provide values for the following environment variables used within the app, using:

```sh
  export MYSQL_USER=<your_database_username>
  export MYSQL_PASSWORD=<your_database_user_password>
  export MYSQL_DATABASE=<your_database_name>
```

- Create a MySQL database and run the `sql` file in the database directory to migrate the database

```sh
  mysql -u <db_user_name> -D <db_name> -p < db/dump.sql
```

- Run `rails s` to start the app in development

## Docker

- Build image

`docker build -t rails_application .`

- Run container
`docker run -it -p 8000:8000 -v $(pwd):/backend rails_application`

## Request and Response Object API guide for all Endpoints

- Check [here](https://docs.google.com/document/d/1J12z1vPo8S5VEmcHGNejjJBOcqmPrr6RSQNdL58qJyE/edit?usp=sharing)
- Visit `http://127.0.0.1:8000`
