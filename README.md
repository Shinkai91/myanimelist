# MyAnimeList

A new Flutter project for exploring and managing anime lists.

## Project Description

This application allows users to explore anime collections with modern Flutter design practices. It provides features like navigation bars, network connectivity, sharing options, and more.

## Features

- Modern UI using `shimmer` and `curved_labeled_navigation_bar`.
- State management using `bloc` and `flutter_bloc`.
- Easy navigation to external URLs using `url_launcher`.
- Offline storage with `shared_preferences`.
- Internet connectivity checks with `connectivity_plus`.
- Sharing anime details via `share_plus`.
- Icons provided by `font_awesome_flutter`.

## Requirements

- Dart SDK: ^3.5.4
- Flutter SDK

## Installation

1. Clone the repository.
2. Navigate to the project directory:
   ```bash
   cd myanimelist
   ```
3. Fetch the dependencies:
   ```bash
   flutter pub get
   ```

## Usage

1. Run the app:
   ```bash
   flutter run
   ```
2. Explore the features and customize the anime list.

## Dependencies

- `flutter`
- `cupertino_icons: ^1.0.8`
- `bloc: ^8.1.4`
- `equatable: ^2.0.7`
- `shimmer: ^3.0.0`
- `curved_labeled_navigation_bar: ^2.0.5`
- `http: ^1.2.2`
- `flutter_bloc: ^8.1.6`
- `url_launcher: ^6.3.1`
- `font_awesome_flutter: ^10.8.0`
- `shared_preferences: ^2.3.5`
- `connectivity_plus: ^6.1.1`
- `share_plus: ^10.1.3`

## Assets

- `lib/assets/splash.jpg`
- `lib/assets/appbar.png`

## Development Dependencies

- `flutter_test`
- `flutter_lints: ^4.0.0`

## Versioning

Version: 1.0.0+1

## API

This application uses the [Jikan API](https://docs.api.jikan.moe/) for fetching anime data.

## Github Repository

You can find the source code [here](https://github.com/Shinkai91/myanimelist).

## License

This project is not intended for publication on pub.dev. Modify the `publish_to` field in `pubspec.yaml` if you wish to publish it.

## Contributing

Feel free to fork the repository and submit pull requests. Feedback and suggestions are welcome!

## Contact

For questions or suggestions, please contact the project maintainers.