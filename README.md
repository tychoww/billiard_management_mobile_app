
## Installation

### Step 1: Download this project and get the packages needed to run the application

![image](https://github.com/tychoww/billiard_management_mobile_app/assets/105794563/d7e27e35-0f75-4815-ae37-980e5ff6870d)


### Step 2: Open config.dart
![image](https://github.com/tychoww/billiard_management_mobile_app/assets/105794563/ef4cfc37-6bd9-47f5-8789-85f33462e6c1)

#### There are 2 options for using API data

If you use an API that has been deployed to a webserver, change the DOMAIN
```
const DOMAIN = 'https://tychoww-billiard-app-backend.onrender.com/api/v1/';
```

If you use local host API, please download the source code later and execute it first
* First, you need to download Local API source 
```
https://github.com/tychoww/billiard-booking-app-backend
```
* Second, get your IP address
    * Open CMD and type:
    ```
    ipconfig
    ```
    * ![image](https://github.com/tychoww/billiard_management_mobile_app/assets/105794563/d4ae7afd-c0be-496c-a7ef-4a4e11e34024)

    * Copy IPV4 Address like this...
    ```
    IPv4 Address. . . . . . . . . . . : 192.168.24.4
    ```

    * Change DOMAIN variable
    ```
    const DOMAIN = '{Your-IP}/api/v1/';
    ```

## App Demo

### Login page
![image](https://github.com/tychoww/billiard_management_mobile_app/assets/105794563/7c45efdc-e21e-4cb0-8514-272b78e3b09d)
### Logout page
![image](https://github.com/tychoww/billiard_management_mobile_app/assets/105794563/4c31611b-2d54-4496-93c3-db3e8b85bd30)

### Client
#### Home page
![image](https://github.com/tychoww/billiard_management_mobile_app/assets/105794563/c12debe3-8734-481c-93f5-cf403e2818ea)
#### Booking Page
![image](https://github.com/tychoww/billiard_management_mobile_app/assets/105794563/1480db63-b3a9-4f17-8f95-3cfaf202e044)

### Client
### Home page
#### Home page with staff role
![image](https://github.com/tychoww/billiard_management_mobile_app/assets/105794563/c24ae169-994f-4a9e-8433-e74c9c83d215)
#### Home page with admin role
![image](https://github.com/tychoww/billiard_management_mobile_app/assets/105794563/e760e37b-44b3-4513-89c3-ef977610df79)

### Table page
#### Table page listview
![image](https://github.com/tychoww/billiard_management_mobile_app/assets/105794563/c37fce9a-8a1a-442c-bcfa-0974e3aaa9ac)

### Food page
#### Food page listview
![image](https://github.com/tychoww/billiard_management_mobile_app/assets/105794563/584af9c8-af72-4505-82dc-6d4cdc55b701)

#### Foodpage filter
![image](https://github.com/tychoww/billiard_management_mobile_app/assets/105794563/8b107a89-befd-4618-a496-22e894698f1e)

#### Foodpage with CRUD
![image](https://github.com/tychoww/billiard_management_mobile_app/assets/105794563/94835ff1-0677-44a8-81b4-b332bc0c2b7c)

### Account management page
![image](https://github.com/tychoww/billiard_management_mobile_app/assets/105794563/64c01bc6-5168-478c-bd1b-dfb71aacc9ac)