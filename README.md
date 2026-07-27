# Neighbourhood Crime Explorer

A responsive Flutter Web app for exploring the latest available street-level
crime data near a UK postcode.

## How it works

1. Postcodes.io suggests matching postcodes as the user types and returns their
   coordinates.
2. The UK Police Data API returns incidents within one mile of that point.
3. BLoCs expose validation and crime loading, success, empty, and error states.
4. The UI derives category totals locally and filters the complete incident
   dataset while rendering results in batches of 50.

## Run

```sh
flutter run -d chrome
```

No API key or authentication is required.

## Verify

```sh
flutter analyze
flutter test
flutter build web --release
```

Police API locations are approximate. In Scotland, only British Transport
Police data is available.
