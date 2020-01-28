# RythmTree
## 1. Requirement

- Debian 9 or windows 10 1903 
- ruby 2.6.3
- Open http port
- change config file (Configuration section)

## 2. Installation 

> `$ represents user's command`\
> `# represents admin's command`

### 2.1 MongoDB

#### 2.1.1 Debian
Install mongoDB Server:
- [official tutorial](https://linuxize.com/post/how-to-install-mongodb-on-debian-9/#installing-mongodb)

Install mongoDB drivers for ruby:\
 `# gem install mongo`
 
#### 2.1.2 Windows 
install mongoDB server:
- [MongoDB Download Center](https://www.mongodb.com/download-center/community?jmp=docs)

Install mongoDB drivers for ruby:\
 `# gem install mongo`

### 2.2 SASS

Install SASS with gem:\
 `# gem install sass`

#### 2.2.1 Start SASS
Run this command in the root of the project \
 `$ sass --watch client\styles\scss\:client\styles\css`

## 3. Configuration

Duplicate `RythmTree/Server/Config/config.rb.example` and rename to `config.rb`.

Open it and change HTTP_PORT to 80, actually is 5678.

## 4. Start

execute the next line from `RythmTree` folder:\
 `$ ruby server/app_start.rb`
 
