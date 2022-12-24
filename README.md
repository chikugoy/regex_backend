# Regex web service backend

frontend : https://github.com/chikugoy/regex_front

## Use 

- Rails
- Firestore
- Firebase Emulator
- Docker

## Ruby and rails info

```bash
$ date
Sat Dec 24 13:45:02 JST 2022
$ rake about
About your application's environment
Rails version      7.0.4
Ruby version       ruby 3.1.2p20 (2022-04-12 revision 4491bb740a) [aarch64-linux]
RubyGems version   3.3.20
Rack version       2.2.4
```

## Deployment

```bash
docker-compose build
docker-compose up -d
```

### Firebase setup

- setting `config/firebase/service_account.json`
  - see https://firebase.google.com/docs/firestore/quickstart#set_up_your_development_environment

```bash
$ docker-compose exec regex_backend_firebase bash
root@328d6705d4cf:/opt/workspace# firebase login --no-localhost
root@328d6705d4cf:/opt/workspace# firebase init
root@328d6705d4cf:/opt/workspace# firebase emulators:start
```

- notes
  - https://github.com/firebase/firebase-tools/issues/4254

## Check it works
  
- api
  - `http://localhost:3000/api/v1/regexes`
- firestore
  - `http://127.0.0.1:4000/firestore`


## Rspec

```bash
docker-compose exec rails_firestore_web bash
bundle exec rspec
```

## Authors

- [@chikugoy](https://www.github.com/chikugoy)

## Badges

Add badges from somewhere like: [shields.io](https://shields.io/)

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)

## License

[MIT](https://choosealicense.com/licenses/mit/)

## 🚀 About Me

I'm a full stack developer...in Tokyo

## 🔗 Links
[![twitter](https://img.shields.io/badge/twitter-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white)](https://twitter.com/develop2015)

