Transport Sync — Flutter Prototype


How to build APK (on your machine):

1) Install Flutter SDK and Android SDK/Android Studio. Follow official Flutter setup.
2) Open this folder in terminal.
3) flutter pub get
4) flutter build apk --release

Notes:
- The app currently uses local storage (shared_preferences). To enable cloud sync, add Firebase initialization and Firestore usage.
- You can install the built APK on your Android device.
