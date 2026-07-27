# Neighbourhood Crime Explorer

A polished, responsive Flutter Web module for exploring the latest available
street-level crime data near a UK postcode.

## Track and APIs

This project follows **Track 02: UK Crime & Safety Explorer**.

- [Postcodes.io](https://postcodes.io/) provides postcode autocomplete,
  validation and coordinates.
- [UK Police Data API](https://data.police.uk/docs/) provides recent
  street-level incidents near those coordinates.

I chose this track because it turns complex public data into a focused,
useful interaction while exposing realistic front-end challenges: slow
responses, missing fields, empty datasets and delayed monthly releases.
Postcodes.io makes the search experience more forgiving, while the Police API
provides reputable, keyless Home Office data.

## Features

- Postcode autocomplete with immediate selection
- Responsive desktop, tablet and mobile layouts
- Light and dark themes
- Loading, error, empty and manual retry states
- Postcode, month, incident and category summaries
- Category breakdown and filterable incident list
- Defensive handling for missing API fields
- Accessible labels and keyboard submission
- Short public-data disclaimer

## Running locally

The project was developed with Flutter 3.41.6 and Dart 3.11.4.

```sh
git clone https://github.com/zakariyakassim/tremorly.git
cd tremorly
flutter pub get
flutter run -d chrome
```

No API key, account or environment configuration is required.

## Architecture

The project uses a small layered structure:

- **Widgets and screens** render ForUI components and responsive layouts.
  Larger sections are split into reusable widgets to keep the home screen
  concise.
- **BLoCs** coordinate postcode validation and crime-loading states without
  placing networking logic in the UI.
- **Services** use Dio for Postcodes.io and UK Police API requests, timeouts and
  response validation.
- **Models and formatters** convert external payloads into safe display values
  and provide sensible fallbacks for incomplete crime records.
- **Theme extensions** keep semantic accent colours consistent across light
  and dark modes.

Dependencies are injected into the screen and BLoCs, which keeps the production
implementation simple while allowing tests to use deterministic fakes.

### Key trade-offs

- Two APIs are used because postcode search and crime lookup have distinct
  responsibilities. This adds one dependency but produces a much better search
  experience than asking users for coordinates.
- Results use the Police API's latest available release. A historical month
  picker was deliberately excluded to keep the module focused.
- Incident filtering and category totals are calculated locally after one
  request. This is fast for the expected response size and avoids extra API
  calls.
- Incidents render in batches of 50 to keep long result sets manageable.
- Models use small manual parsers instead of code generation because there are
  only two compact payload shapes.
- Maps, authentication and persistence were intentionally excluded as they do
  not improve the core postcode-to-insight flow for this timebox.

## Resilience

- Network connections and responses have ten-second timeouts.
- Invalid postcodes, unavailable services and malformed responses produce
  readable user-facing errors.
- Crime records use safe defaults for missing categories, locations, months and
  outcomes.
- Postcode records without usable coordinates are ignored.
- Autocomplete requests are debounced and stale suggestion results are
  discarded.
- Crime-loading failures and empty results provide explicit retry actions.

## Testing

Run the complete verification suite with:

```sh
flutter analyze
flutter test
flutter build web --release
```

The service tests verify postcode query normalization, autocomplete parsing and
coordinate parsing. The widget test covers the critical user journey:
autocomplete selection, automatic crime loading, summary rendering, theme
switching and incident filtering.

### Manual QA plan

1. Check the layout at mobile, tablet and wide desktop widths.
2. Toggle light and dark modes and confirm readable contrast throughout.
3. Search for a valid postcode using both autocomplete and the Enter key.
4. Try an invalid or incomplete postcode and confirm the field-level error.
5. Test with offline or throttled networking and confirm loading, error and
   retry behaviour.
6. Verify an empty response produces the dedicated empty state.
7. Filter a large incident list by category, street, outcome and month.
8. Navigate the search and controls with the keyboard.
9. Smoke-test the release build in current Chrome, Firefox and Safari.

## Known limitations

- Police data is approximate, released monthly and may not represent every
  incident. In Scotland, only British Transport Police data is available.
- The API controls the latest available month; the module does not offer
  historical browsing.
- Successful responses are not cached between searches or page refreshes.
- Rate limits and temporary server failures use a general retry state rather
  than automatic backoff or `Retry-After` handling.
- The automated suite focuses on the primary successful journey; additional
  outage, malformed-payload and empty-state tests would further strengthen it.

## With more time

- Add short-lived in-memory caching keyed by postcode and release month.
- Add rate-limit-aware retry with bounded exponential backoff.
- Make overlapping crime requests restartable so only the latest selection can
  update the UI.
- Expand service and widget tests for outages, empty data and malformed
  payloads.
- Perform a dedicated accessibility audit with multiple browsers, screen
  readers and increased text scaling.

## AI usage

OpenAI Codex was used as a development assistant for API integration, UI
iteration, refactoring, test creation and documentation. Generated suggestions
were reviewed against the installed package APIs and project architecture, then
validated with formatting, static analysis, automated tests and a release web
build.
