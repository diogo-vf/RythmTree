# RythmTree
## Requirement

- Debian 9 (not windows, because mongoDB drivers for ruby doesn't work)
- package sudo
- ruby 2.6.3
- Open http port

## Installation

> `$ represents user's command`\
> `# represents admin's command`

### MongoDB

Install mongoDB Server:
- [official tutorial](https://linuxize.com/post/how-to-install-mongodb-on-debian-9/#installing-mongodb)

Install mongoDB drivers for ruby:\
 `# gem install mongo`

### SASS

Install SASS with gem:\
 `# gem install sass`

#### Start SASS
Run this command in the root of the project \
 `$ sass --watch client\styles\scss\:client\styles\css`

## Configuration

Duplicate `RythmTree/Server/Config/config.rb.example` and rename to `config.rb`.

Open it and change HTTP_PORT to 80, actually is 5678.

## Start

execute the next line from `RythmTree` folder:\
 `$ ruby server/app_start.rb`