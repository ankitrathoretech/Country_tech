**CountryTech**

CountryTech is a API based application that allows clients to browse and search for countries. This repository contains the source code for the application, as well as installation and usage instructions.


**Features**

1. **GET /countries**
   - Endpoint: `/countries`
   - Purpose: Retrieve a list of countries with pagination support.
   - Parameters:
     - `page` (optional): Specifies the page number for pagination (default is 1).
     - `per_page` (optional): Specifies the number of countries to display per page (default is a predefined value).
   - Response: Returns a JSON object containing a list of countries and the total count of countries available.

2. **GET /countries/search**
   - Endpoint: `/countries/search`
   - Purpose: Search for countries based on specific filter criteria.
   - Parameters:
     - `alpha_2_code` (optional): Filter countries by their 2-letter alpha code.
     - `alpha_3_code` (optional): Filter countries by their 3-letter alpha code.
     - `currency` (optional): Filter countries by their currency code.
   - Response: Returns a JSON object containing filtered countries based on the provided criteria. If no matches are found or no filter is provided, an appropriate error message is returned.

3. **DELETE /countries/:id**
   - Endpoint: `/countries/:id`
   - Purpose: Delete a specific country by its unique ID.
   - Parameters:
     - `:id`: The unique identifier of the country to be deleted.
   - Response: Returns a JSON message indicating whether the country was successfully deleted or if there was an error during deletion.

These endpoints provide functionality for retrieving a list of countries, searching for countries based on specific criteria, and deleting individual countries. The endpoints are designed to handle various filtering options and error scenarios to ensure a robust API experience.

**Technologies**

The application is built using the following technologies:

    Postgresql: for the database to store countries information
    Ruby (3.2.2): for the core language of Rails framework.
    Rails (7.0.2): Web application framework build in ruby programming language.
    RSpecs: for automated testing.

**Postman Collection**

I have also attached the postman collection in project directory. https://github.com/alkeshrails/CountryTech/blob/main/CountryTech.json


**Installation**

To install and run the application locally, follow these steps:

To clone the repository

`git clone https://github.com/alkeshrails/CountryTech.git`

Install the dependencies for the server and client:

1. `cd CountryTech`
2. `bundle install`
3. `cp config/database.yml.sample config/database.yml`  run this command and change the postgresql config as per your machine.
4. `bundle exec rails db:create db:migrate db:seed`

after running this command make sure all the test cases are green(passed).

We can verify it by running
`bundle exec rspec`

Once the test cases are green, you can use it to browse and search for countries.

## Proposed Improvement: Separate Table for Currencies

### Problem Statement

In our current Rails application, we have a `Country` table with a `currency` column. While this setup allows us to associate a single currency with each country, it does not fully capture the complexity of the real-world scenario. Many countries have multiple currencies, and a single currency can be used by multiple countries. This oversimplified representation limits our ability to handle advanced currency-related functionality.

### Proposed Solution

To address this limitation and enhance our application's flexibility and functionality, we propose the following improvement:

**1. Create a New Table for Currencies**

- We should create a dedicated table for currencies, which will store information about various currencies independently.

**2. Establish a Many-to-Many Association**

- Implement a many-to-many association between the `Country` and `Currency` tables using a join table. This association will allow us to handle cases where a country can have multiple currencies and a currency can be used by multiple countries.

**3. Benefits and Additional Features**

- This improvement opens up several possibilities for extending our application's functionality:
  - **Currency Conversion Rate**: We can easily implement currency conversion functionality, allowing users to convert between different currencies.
  - **Last Updates on Currency**: We can track and display information about the last updates or changes made to each currency.
  - **Active/Inactive Currency**: We can introduce a status flag to mark currencies as active or inactive, providing better control over which currencies are available for use.


Thanks


