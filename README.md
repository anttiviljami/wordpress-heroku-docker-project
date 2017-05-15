# WP Heroku Docker Project
[![Build Status](https://travis-ci.org/anttiviljami/wordpress-heroku-docker-project.svg?branch=master)](https://travis-ci.org/anttiviljami/wordpress-heroku-docker-project) [![License](http://img.shields.io/:license-gpl3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0.html)

The Holy Grail WordPress project template for Heroku deployment and local Docker development.

## Features

- [x] Bedrock-like modern development environment
- [x] Deployment to Heroku pipelines
- [x] Local Heroku-like environment with Docker-compose
- [x] PHP 7
- [x] WP-CLI
- [x] Configurable Nginx
- [x] Redis Object Cache
- [x] Travis CI pipeline you can run with Docker
- [x] PHP Codesniffer with nicer coding standards for WordPress
- [x] Media Uploads to S3
- [x] Newrelic APM monitoring
- [x] Papertrail log management
- [x] Environment management for complete `local`, `development`, `qa` and `production` pipeline
- [x] [CloudFormation script](https://github.com/anttiviljami/wordpress-heroku-docker-project/blob/master/tools/cloudformation.json)
for provisioning a MariaDB RDS instance and an S3 bucket on AWS
- [ ] Scripts for automating deployment, synchronising databases
- [ ] Basic integration tests

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

If you want, you can now install WordPress with `tools/install-wordpress.sh`
```bash
$ ./tools/install-wordpress.sh
2/6 --title=<site-title>: My WordPress Site
Success: WordPress installed successfully.
Plugin 's3-uploads' activated.
Success: Activated 1 of 1 plugins.
Success: The cache was flushed.
----> WordPress installed succesfully!
```

Outside the docker shell, you can now start the main process

```bash
docker-compose up web
```

You can now navigate to [`http://localhost:8080`](http://localhost:8080) to
start working with your local WordPress installation.

## WP-CLI

You can run WP-CLI locally by starting the shell container

```
docker-compose run shell
```

To run wp-cli in a Heroku instance, just run a temporary bash dyno.

```
heroku run bash
```

Both environments have WP-CLI available as `wp`.

## Running tests

Travis will run the `ci` container to test your app. You can do the same
locally!

```
docker-compose up ci
```

## Deployment to Heroku

Set up a new app on Heroku for your WordPress project.

Use the included
[CloudFormation script](https://github.com/anttiviljami/wordpress-heroku-docker-project/blob/master/tools/mariadb-cloudformation.json)
to provision a MariaDB instance and an S3 bucket for uploads on AWS.

<a href="https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=wordpress-heroku&templateURL=https://s3.eu-central-1.amazonaws.com/cf-templates-6kuoc24dql6e-eu-central-1/2017135qFR-cloudformation.json" target="_blank"><img alt="Launch Stack" src="https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png"></a>

The script will output the values needed for Heroku config variables:

![AWS Cloudformation script output](https://cloud.githubusercontent.com/assets/6105650/26060801/cef914ae-398e-11e7-85d0-c916e88bee37.png)

```bash
heroku config:set \
  WP_ENV=development \
  DATABASE_URL=
  S3_UPLOADS_BUCKET=<replace> \
  S3_UPLOADS_KEY=<replace> \
  S3_UPLOADS_SECRET=<replace> \
  S3_UPLOADS_REGION=<replace>
```

Make sure to also set up your `WP_ENV` variable for Heroku. It should be one of:

- `development`
- `qa`
- `production`


I strongly recommend also enabling at least the following addons for your
Heroku app:

- Papertrail
- Redis
- NewRelic APM

You can now push to Heroku! Here's an example of a WordPress instance running
on Heroku:

[wp-project-dev.herokuapp.com](https://wp-project-dev.herokuapp.com/)

This is how your project should look like on Heroku:

![Heroku App Dashboard](https://cloud.githubusercontent.com/assets/6105650/26061040/7f62fc42-398f-11e7-82de-a6b9c642fb67.png)

![Heroku Pipeline](https://cloud.githubusercontent.com/assets/6105650/26045817/91526a9a-3954-11e7-8756-ba7cf5a5405c.png)
