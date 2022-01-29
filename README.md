# Soccer Online Team Management API
#### _An Api Application where user can login/signup to create their fantasy soccer team and transfer players_
- User can Login/Signup
- User can edit their team name & country
- User can edit their player's name & country
- User can put their players on transfer list
- User can buy players from transfer list

## Development
- This is a Ruby(2.7.3) on Rails(6.1.4) API only application.
- The database used is MongoDB (Gem mongoid).
- The application uses Rspec for test cases.

After cloning the repository. Execute the following steps in terminal.
```sh
cd <path-to-repo>
bundle install
rake db:seed # This will seed countries in the database. Refer country_seed.rb for more details
rails s # rails server
```
Your server will start at ```http://localhost:3000```

## Schema
- User
  - has_one Team
- Team
  - belongs_to User
  - has_many Players
  - belongs_to Country
- Player
  - belongs_to Team
  - belongs_to Country
- Country

Note: Although MongoDB is a non-relational database, the ODM provided by Mongoid gem allows this to be possible. Behind the scenes the relations are stored in a non-relational way

## Testing
Test Cases are written using Rspec (with Faker, FactoryBot).
To run test cases on file(s) ```rspec .``` or ```rpsec spec/<filename>```

## API Endpoints
#### USERS
Users#Create - Signup/Create a User.
- The password is encrypted on creation.
- Successful response will have a JWT Token to access authorized APIs
```
# POST http://localhost:3000/api/v1/users
Body => {
  "user": {
    "email": <Your email>,
    "password": <Password - Length 8>
  }
}
```

#### SESSIONS
Sessions#Create - Login a User.
- Successful response will have a JWT Token to access authorized APIs
```
# POST http://localhost:3000/api/v1/sessions
Body => {
  "email": <Your email>,
  "password": <Password - Length 8>
}
```

#### TEAMS
Teams#Index - Lists User's Team & Players.
```
# GET http://localhost:3000/api/v1/teams
Headers => {
  "Authorization": <JWT Token>
}
```

Teams#Update - Update teams name & country
```
# PUT http://localhost:3000/api/v1/teams/:id
Headers => {
  "Authorization": <JWT Token>
}

Body => {
  "team": {
    "name": <Team Name>,
    "country_id": <Country Code - Ex. 'ca', 'in'. Refer Countries#Index for the list>
  }
}
```

#### PLAYERS
Players#Update - Update players name & country
```
# PUT http://localhost:3000/api/v1/players/:id
Headers => {
  "Authorization": <JWT Token>
}

Body => {
  "player": {
    "first_name": <First Name>,
    "last_name": <Last Name>,
    "country_id": <Country Code - Ex. 'ca', 'in'. Refer Countries#Index for the list>
  }
}
```

Players#transfer - Put player on transfer list
```
# PATCH http://localhost:3000/api/v1/players/:id/transfer
Headers => {
  "Authorization": <JWT Token>
}

Body => {
  "transfer_value": <positive number>
}
```

Players#buy - Buy player from the transfer list
```
# PATCH http://localhost:3000/api/v1/players/:id/buy
Headers => {
  "Authorization": <JWT Token>
}
```

#### TRANSFERS
Transfers#Index - Lists Players on transfer list.
```
# GET http://localhost:3000/api/v1/transfers
Headers => {
  "Authorization": <JWT Token>
}
```

#### COUNTRIES
Countries#Index - Lists of countries with their code.
```
# GET http://localhost:3000/api/v1/countries
Headers => {
  "Authorization": <JWT Token>
}
```
