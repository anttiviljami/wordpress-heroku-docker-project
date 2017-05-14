# WP Heroku Docker Project
[![License](http://img.shields.io/:license-gpl3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0.html)

WordPress project template for Heroku deployment and local Docker development.

## Local Development

Install [Docker](https://www.docker.com/)

Clone this repo and source set up your environment inside the project root.

```bash
cp .env.sample .env
source .env
```

I also recommend installing [autoenv](https://github.com/kennethreitz/autoenv),
so you don't have to run the source command all the time.

Start a shell inside Docker. It might take a moment for the images to download
and build. This is normal.

```bash
docker-compose run shell
```

Now you can run `composer install` inside Docker

```bash
composer install
```

At this stage, you can use wp-cli to install WordPress (optional), or just
exit the Docker container to finish WordPress installation later.

Outside the docker shell, you can now start the main process

```bash
docker-compose up web
```

You can now navigate to [`http://localhost:8080`](http://localhost:8080) to
start working with your local WordPress installation.

## Deployment to Heroku

Set up a new app on Heroku, you need at least the ClearDB addon for your
database.

Make sure you set up S3 uploads and set your `WP_ENV` variable for Heroku

```bash
heroku config:set \
  WP_ENV=development \
  S3_UPLOADS_BUCKET=my-bucket \
  S3_UPLOADS_KEY=<replace> \
  S3_UPLOADS_SECRET=<replace> \
  S3_UPLOADS_REGION=eu-central-1
```

You can now push to Heroku! Here's an example of a WordPress instance running
on Heroku:

[wp-project-dev.herokuapp.com](https://wp-project-dev.herokuapp.com/)

