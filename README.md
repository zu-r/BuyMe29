# BuyMe29 - Online Auction Marketplace

## Overview
BuyMe29 is a web-based online auction platform where users can bid on vehicles, post auctions, and manage their accounts. The platform supports multiple user roles, including regular users, customer representatives, and administrators, each with specific functionalities.

## Features

### General Features
- **User Authentication**: Login and account creation for users.
- **Auction Listings**: View ongoing and completed auctions.
- **Search and Filter**: Search for auctions by make, model, and year with sorting options.
- **Alerts**: Receive alerts for outbid notifications and auction updates.

### User Features
- **Place Bids**: Bid on auctions manually or set auto-bid limits.
- **Manage Auctions**: Post new auctions and view ongoing/completed auctions.
- **Favorites**: Add auctions to a list of interested items.
- **Help Requests**: Submit help requests to customer representatives.

### Customer Representative Features
- **Manage Users**: Update user passwords and delete user accounts.
- **Manage Auctions**: Remove bids and auctions.
- **Help Requests**: View and resolve help requests from users.

### Administrator Features
- **Manage Customer Representatives**: Create and delete customer representative accounts.
- **Sales Reports**: View reports on total earnings, earnings per item, best-selling items, and best buyers.


## Key Files

- **[`ApplicationDB.java`](src/main/java/com/cs336/pkg/ApplicationDB.java)**: Manages database connections.
- **`web.xml`**: Configures the web application and defines welcome pages.
- **JSP Files**:
  - [`src/main/webapp/login.jsp`](src/main/webapp/login.jsp): User login and account creation.
  - [`src/main/webapp/myBids.jsp`](src/main/webapp/myBids.jsp): View and manage user bids.
  - [`src/main/webapp/myAuctions.jsp`](src/main/webapp/myAuctions.jsp): View and manage user auctions.
  - [`src/main/webapp/PostAuction.jsp`](src/main/webapp/PostAuction.jsp): Create new auctions.
  - [`src/main/webapp/admin.jsp`](src/main/webapp/admin.jsp): Administrator dashboard.
  - [`src/main/webapp/customer_rep.jsp`](src/main/webapp/customer_rep.jsp): Customer representative dashboard.
  - [`src/main/webapp/sales_report.jsp`](src/main/webapp/sales_report.jsp): View sales reports.

## Database

The application uses a MySQL database named `BuyMe29`. Key tables include:
- `users`: Stores user information and roles.
- `auctions`: Stores auction details.
- `bids`: Tracks user bids on auctions.
- `vehicles`: Stores vehicle details.
- `alert_inbox`: Stores alerts for users.
- `help_requests`: Tracks help requests submitted by users.

## Setup Instructions

### Prerequisites
- Java 17 or higher.
- Apache Tomcat 8.5 or higher.
- MySQL database server.

### Steps
1. **Database Setup**:
   - Import the database schema into MySQL.
   - Update database credentials in [`ApplicationDB.java`](src/main/java/com/cs336/pkg/ApplicationDB.java).

2. **Build and Deploy**:
   - Compile the project using Eclipse or any Java IDE.
   - Deploy the project to an Apache Tomcat server.

3. **Access the Application**:
   - Open a browser and navigate to `http://localhost:8080/BuyMe29`.

## Usage

### User Roles
- **Regular Users**:
  - Login to place bids, post auctions, and manage favorites.
- **Customer Representatives**:
  - Login to manage user accounts, resolve help requests, and remove auctions/bids.
- **Administrators**:
  - Login to manage customer representatives and view sales reports.

### Navigation
- Use the navigation bar on each page to access features like "My Bids," "My Auctions," "Help," and "Logout."

## License
This project is for educational purposes and is not intended for production use.
