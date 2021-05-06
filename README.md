# Reward Engine

The objective of this project is to implement a simple API that receive requests from a SDK.

## Tech

- Ruby v3.0.1
- Rails v6.1.3.1
- Postgres v13
- HTTParty v0.18.1
- config v3.1


## Run

`docker-compose up -d`

Access `localhost:3000/users`

## How to use

There is a Postman [collection](https://www.getpostman.com/collections/87097dfec79fc8c87a4e) to help with the requests to the application

## Development

Start server `rails c` </br>

## Endpoints

```
POST /api/v1/user_events
```
Responsible to receive and process the events of user sent by the SDK </br>
Contract example .:

| type                   | user_id       |    
| ---------------------- |:-------------:|
| UserAuthenticated      | 1            |

| type                   | user_id       |    payment_due_date | payment_date| payment_amount
| ---------------------- |:-------------:|:-------------:|:-------------:|:-------------:|
| UserPaidBill      | 1            |2021-05-02 | 2021-05-02| 10000

| type                   | user_id       |    user_bank | 
| ---------------------- |:-------------:|:-------------:|
| UserMadeDepositIntoSavingsAccount      | 1            |BANK_LOPAM |

</br></br>

```
GET /api/v1/rewards
```
Responsible to return the available rewards that a user can redeem</br>
Contract example .:

| user_id       |    
|:-------------:|
| 1            |

</br></br>

```
POST /api/v1/users/:user_id/redeems
```
Responsible to receive and process when a user redeem a reward</br>
Contract example .:

| type                   | user_id       |    
| ---------------------- |:-------------:|
| UserAuthenticated      | 1            |

</br></br>