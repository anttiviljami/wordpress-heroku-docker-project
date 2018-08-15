# WP Heroku Docker Project
[![Build Status](https://travis-ci.org/anttiviljami/wordpress-heroku-docker-project.svg?branch=master)](https://travis-ci.org/anttiviljami/wordpress-heroku-docker-project) [![License](http://img.shields.io/:license-gpl3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0.html)

The Holy Grail WordPress project template for Heroku deployment and local Docker development.

<a href="https://youtu.be/ClXEgS-Z-pI" target="_blank"><img alt="Play Video" width=720 src="https://cloud.githubusercontent.com/assets/6105650/26076788/9cc057b6-39c2-11e7-8339-082ab9654751.png"></a>

[Video Tutorial](https://youtu.be/ClXEgS-Z-pI) available on YouTube

## Features

- [x] Bedrock-like modern development environment
- [x] Local Heroku-like environment with Docker-compose
- [x] WP-CLI
- [x] Configurable Nginx
- [x] Travis CI pipeline you can run with Docker
- [x] PHP Codesniffer with nicer coding standards for WordPress
- [x] Terraform deployment for full WordPress stack provisioning to Heroku & AWS
- [x] Heroku PHP7 & Node 8 application runtime
- [x] Heroku Redis Cache
- [x] AWS S3 for media uploads
- [x] AWS RDS for MariaDB
- [x] Papertrail log management
- [x] NPM scripts for ease of use

## Local Development

Install [Docker](https://www.docker.com/)

Install [Node.js](https://nodejs.org/en/download/)

Install [AWS-CLI](https://aws.amazon.com/cli/)

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
npm run shell
```

Now you can run `composer install` inside Docker

```bash
composer install && exit
```

Outside the docker shell, you can now start the main process

```bash
npm start
```

You can now navigate to [`http://localhost:8080`](http://localhost:8080) to
start working with your local WordPress installation.

## Deploying with Terraform

To deploy using Terraform, make sure you've prepared Heroku and AWS credentials,
and you've installed the [Terraform CLI binary](https://www.terraform.io/downloads.html)
on your system.

You can get your Heroku API key from the Heroku dashboard
```
export HEROKU_API_KEY=
export HEROKU_EMAIL=
```

For AWS, create an IAM user with Administrator rights
```
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
```

The state of Terraform is managed in S3, so it should automatically sync any
changes from the remote backend. For this you'll need to manually set up an S3
bucket in the eu-west-1 region with the name `wp-terraform-backend`

```
terraform init
terraform apply
```

After this you can push to your newly created Heroku app's git URL to trigger
a Heroku deployment.

```
git remote add dev https://git.heroku.com/[my-project-name]-dev.git
git push dev
```

## WP-CLI

You can run WP-CLI locally by starting the shell container

```
npm run shell
```

To run wp-cli in a Heroku instance, just run a temporary dyno.

```
heroku run bash
```

Both environments have WP-CLI available as `wp`.

## Running tests

Travis CI will run the `ci` container to test your app. You can do the same
locally:

```
npm test
```
