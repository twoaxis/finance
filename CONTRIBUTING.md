# How to contribute

TwoAxis Finance is built entirely on Firebase, and the mobile client is built using Flutter.

## Running the Firebase Emulator Suite
In order to contribute, you must use the Firebase Emulator Suite.

- Make sure that you have Firebase Tools CLI installed: `npm install -g firebase-tools`
- Run Firebase emulators locally: `firebase emulators:start`

## Running the mobile app
- Open the `mobile/` directory in Android Studio (or IDE that supports Flutter).
- Run `main.dart` in development mode (`assembleDebug`)

Note: The mobile client connects to the Firebase Emulators in debug mode only (`kDebugMode`). You may change this in `lib/main.dart`, but do not commit your changes.

## Running the web app
- Open the `web/` directory in any IDE you'd like.
- Run `npm install` to install all the dependencies.
- Run `npm run dev` to run the app locally.

Note: The web client connects to the Firebase Emulators in `localhost`. You may change this in `lib/firebase/firebase.ts`, but do not commit your changes. If you'd like to connect to the real Firebase project, use `https://127.0.0.1:3000` instead.


## Pull Requests
Your pull requests will be reviewed throughly, please submit many small pull requests rather than one big one. 
Make sure to assign proper labels to your pull request as it will impact the review.
Include a description with your pull request that includes an overview of what the pull request changes.
