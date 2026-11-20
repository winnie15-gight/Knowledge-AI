# KNOWLEDGE AI — Android source project

This ZIP contains the Flutter client source generated from the supplied project builder, with the Render base URL set to `https://lovewise-flow.onrender.com` and Android Gradle scaffolding added.

## Important status

This is a **source project, not an APK**. The Flutter screens and Android project files are included, but the mobile authentication/settings/history endpoints assumed by the original client are not present in the current Flask backend. The existing backend uses Flask browser sessions, while the Flutter client currently expects token-based `/api/auth/*` endpoints. Therefore, login/signup and some account features are **not yet end-to-end connected**. The existing `/api/chat` endpoint also requires an authenticated Flask session cookie. Do not deploy backend changes or alter the production database just to test this source archive.

## Build environment

Install Flutter (stable), Android Studio/Android SDK, and a compatible JDK 17. From this folder run:

```bash
flutter create .
flutter pub get
flutter analyze
```

Then build a debug APK after the backend authentication adapter has been implemented and tested:

```bash
flutter build apk --debug --dart-define=BACKEND_BASE_URL=https://lovewise-flow.onrender.com
```

The output is normally `build/app/outputs/flutter-apk/app-debug.apk`.

## Backend integration still required

Implement and test a secure mobile API adapter on the Flask backend that supports signup, login, 2FA verification/resend, logout, chat history, settings read/update, and feedback. It must authenticate users without exposing secrets, use the existing user and messages tables, and preserve existing web login behavior. The current mobile client must then be updated to match the actual request/response schema and secure session/token mechanism.

## Branding

Public app name: **KNOWLEDGE AI**. The Render hostname remains `lovewise-flow.onrender.com` because the deployed service URL was not renamed.
