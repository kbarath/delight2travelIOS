# Delight2Travel iOS

Native iOS travel app (SwiftUI, iOS 16+) that lets users enter an origin city, optional layover cities, and a destination city, then fetches the list of required travel documents from the API.

## Setup

1. Open `Delight2Travel.xcodeproj` in Xcode.
2. Select the **Delight2Travel** scheme and an iOS Simulator (e.g. iPhone 16).
3. Build and run (⌘R).

## API

The app calls the n8n webhook at:

- `https://n8n.srv1148585.hstgr.cloud/webhook/dc3ae967-f844-47f4-8f53-f071a8e60181`

**Request:** `POST` with JSON body:

- `origin`: string  
- `layovers`: array of strings (optional)  
- `destination`: string  

**Response:** JSON with either:

- `documents`: array of `{ "name": string, "leg": string? }`, or  
- `byLeg`: object mapping leg name to array of document names  

To change the base URL, edit `Delight2Travel/Core/API/Configuration.swift`.

## Tests

- **Unit tests:** `Delight2TravelUnitTests` – view models (with mock API), API client decoding, request/response models. Run with ⌘U or the Test action.
- **UI tests:** `Delight2TravelUITests` – form elements, add layover, submit and navigate to results. Run in the simulator.

## Structure

- **App** – `@main` and root `NavigationStack`
- **Features/TripInput** – form (origin, layovers, destination), “Go” → API call and navigation
- **Features/Results** – required documents, popular destinations, services
- **Core/API** – client, endpoint, configuration, errors
- **Core/Models** – `TripRequest`, `TravelDocumentsResponse`
- **Core/Theme** – colors, typography, `CardView`, `PrimaryButton`, gradient background
