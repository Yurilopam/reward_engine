# Reward Engine

The objective of this project is to implement a simple API that receive requests from a SDK.

## Stack

- Ruby v3.0.1
- Rails v6.1.3.1

## Development

Start server `rails c` </br>
There is a [Postman](https://www.postman.com/downloads/) collection to help with the requests to the application


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