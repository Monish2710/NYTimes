# NYTimes Most Popular Articles App

This project is a SwiftUI and UIKit application designed to fetch and display the most popular articles from the New York Times API. It demonstrates modern approaches in Swift development, including data management with Core Data, efficient UI rendering, and robust testing practices.

## API Endpoint

The app fetches data from the following New York Times API endpoint:
- **URL**: [NYTimes Most Popular Articles](http://api.nytimes.com/svc/mostpopular/v2/mostviewed/all-sections/7.json?api-key=x2gTwp3LfLER5oxUEqYwYSGHTNCWAx9C)
- **API Key**: x2gTwp3LfLER5oxUEqYwYSGHTNCWAx9C

## Features

- Fetches popular articles from the NYTimes API.
- Displays articles in a SwiftUI list.
- Efficiently manages data storage with Core Data.
- Provides a modern and responsive UI.
- Includes comprehensive unit and UI tests.

## Getting Started

### Prerequisites

- Xcode 15 or later
- Swift 5.8 or later
- An active internet connection for fetching data from the NYTimes API

### Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/nytimes-articles-app.git

## Project Structure

### Models

 - ResultModel: Represents an article with properties like title, byline, publishedDate, and media.
 - NYTimesResponse: Encapsulates the API response, including status, number of results, and a list of articles.

### Networking

 - APIClient: Handles API requests and responses using URLSession and JSONDecoder.
Data Management
 - Core Data: Stores articles for offline use.
 - PersistenceManager: Manages the Core Data stack.
 - NYTimesDataModel: Core Data entity for storing article data.
 - ListViewController: Handles Core Data operations and updates.

### UI

 - SwiftUI Views:
  - ContentView: Displays the list of articles using ArticleRowView.
  - ArticleRowView: Represents each article in the list.
  - URLImage: Custom view for loading images from URLs.

 - UIKit Integration:
  - ListViewController: A UIViewController that integrates with NSFetchedResultsController for Core Data.

- Testing
   - Unit Tests: Validates Core Data operations and API responses.
   - UI Tests: Ensures UI components render correctly and handle user interactions.

- Usage
   - Fetch and Display Articles:

Articles are fetched automatically when the app launches or when the view appears.
The data is displayed in a SwiftUI List with each article represented by an ArticleRowView.

- Error Handling
   - Network Errors: Display an alert if there is an issue with fetching data.
   - Data Handling Errors: Log errors related to Core Data operations.
