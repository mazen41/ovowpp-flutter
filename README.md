#OvoWpp
Complete Cross Platform WhatsApp CRM and Marketing Tool | Web and Mobile App | SaaS


## Firebase Setup (Required)

This source does not include live vendor Firebase credentials.

1. Create your own Firebase project.
2. Register Android and iOS apps with your bundle/package IDs.
3. Add Android config:
   - Copy `android/app/google-services.json.example` to `android/app/google-services.json`.
   - Replace placeholder values with your real Firebase Android config.
4. Add iOS config:
   - Place your `GoogleService-Info.plist` in `ios/Runner/GoogleService-Info.plist`.
5. Regenerate `lib/firebase_options.dart` using FlutterFire CLI:
   - `dart pub global activate flutterfire_cli`
   - `flutterfire configure`
   - You can also use Firebase CLI first to manage/select the Firebase project, then run FlutterFire CLI.
     Example:
     - `npm i -g firebase-tools`
     - `firebase login`
     - `firebase use --add`
     - `flutterfire configure`
6. Rebuild the app.

Notes:
- `android/app/google-services.json` and `ios/Runner/GoogleService-Info.plist` are ignored by git.
- Push notifications require valid Firebase setup.
