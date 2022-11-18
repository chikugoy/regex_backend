# README

rails api for docker  
use firestore local emulator

### Ruby and rails info

```shell
$ rake about
About your application's environment
Rails version             7.0.4
Ruby version              ruby 3.1.2p20 (2022-04-12 revision 4491bb740a) [x86_64-linux]
RubyGems version          3.3.20
Rack version              2.2.4
```

### Start up

```shell
docker-compose build
#docker-compose run rails_firestore_web rails db:create
#docker-compose run rails_firestore_web rake db:migrate
docker-compose up -d
```

### Firebase setup

- setting `config/firebase/service_account.json`
  - see https://firebase.google.com/docs/firestore/quickstart#set_up_your_development_environment

```shell
$ docker-compose exec rails_firestore_firebase bash
root@328d6705d4cf:/opt/workspace# firebase login --no-localhost
root@328d6705d4cf:/opt/workspace# firebase init
root@328d6705d4cf:/opt/workspace# firebase emulators:start
```

- notes
  - https://github.com/firebase/firebase-tools/issues/4254

### Check it works
  
- api
  - `http://localhost:3000/api/v1/regexes`
- firestore
  - `http://127.0.0.1:4000/firestore`


### Rspec execute

```shell
docker-compose exec rails_firestore_web bash
bundle exec rspec
```
