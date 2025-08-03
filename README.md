

# City Tour 🏙️

## What is this App All About

This is a simple SwiftUI app that fetches and displays nearby places based on the user's current location. It uses the Google Places API to find points of interest like coffee shops, restaurants, and museums. Users can filter places by category and view a list of results with the place's name, address, rating, and a photo.

- **Location-Based Search**: The app fetches places near the user's current location using Core Location.
- **Dynamic Keyword Filtering**: Users can select different categories, like "Coffee Shops," "Burgers," or "Museums," to filter the results.
- **Asynchronous Data Handling**: The app utilizes async/await for efficient and non-blocking network requests.
- **Custom Error Handling**: A dedicated enum (PlacesError) is implemented to handle various API and network-related issues.
- **Clean UI**: The user interface is built with SwiftUI, presenting information in a clear list, and uses AsyncImage for loading photos.

## What I have learned

- **Asynchronous Programming with `async/await`**: I used `async` and `await` to handle network requests, making the code more readable and preventing UI freezes.
- **Error Handling**: I implemented robust error handling with a custom enum (PlacesError) to manage network-related issues such as invalidURL, invalidResponse, and serverError.
- **JSON Decoding**: I learned how to decode JSON data from the API response into a custom Swift struct (PlacesResponseModel) using Codable.
- **SwiftUI Layouts**: I used VStack and HStack to arrange UI elements for the place rows and keyword list, creating a responsive design.
- **State Management**: I managed the app's state with the @StateObject property wrapper to observe changes from the PlacesViewModel and update the UI when new data is received.

## Note

- To make this app work on you device Kindly add you api keys from [GoMaps(Free)](https://app.gomaps.pro/)
- API your needs to be added in Files Such as APIClient.swift(API Folder) and PlaceRowModel.swift(Models Folder)

## Demo

![Demo](https://github.com/user-attachments/assets/50373778-47a5-4804-bffd-6cae4b88e12c)

