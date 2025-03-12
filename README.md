# Maptivity iOS

A SwiftUI-based iOS application for tracking activities using Mapbox for mapping and visualization. This app is currently under active development.

## Overview

Maptivity allows users to record, view, and manage their activities with detailed metrics while visualizing routes on maps.

## Current Features

- **User Authentication**: Login, signup, and token refresh
- **Activity Tracking**: Record activities with start/end times and route data
- **Mapbox Integration**: Visualize routes and activity data on interactive maps
- **Activity Metrics**: Distance, speed, elevation data, and other statistics

## Requirements

- iOS 15.0+
- Xcode 14.0+
- Swift 5.7+
- CocoaPods or Swift Package Manager
- Mapbox account & SDK access token

## Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/your-app-name-ios.git
   cd your-app-name-ios
   ```

2. Install dependencies:
   ```bash
   # If using CocoaPods
   pod install
   
   # If using Swift Package Manager
   # Open the project in Xcode and resolve packages
   ```

3. Create a `Config.xcconfig` file with your Mapbox access token:
   ```
   MAPBOX_ACCESS_TOKEN=your_mapbox_access_token_here
   API_BASE_URL=your_backend_api_url_here
   ```

4. Open the project in Xcode and run.

## Development Status

Maptivity is currently under active development and is not yet feature complete. Upcoming work may include and is not limited to:

- Comprehensive testing
- UI refinements
- Additional activity analysis features
- Offline support

## Backend

This app requires the [Maptivity backend API](https://github.com/ericbatiste/maptivity_be) for data persistence and authentication.
