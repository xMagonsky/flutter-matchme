# MatchMe

**A swipe-based mobile application to connect people seeking roommates or rental spaces.**

MatchMe simplifies the process of finding a compatible roommate or rental space. Whether you're a Seeker looking for a place to live or a Tenant offering a room, this app connects users through an intuitive swiping mechanism, inspired by modern dating apps, adapted for the housing market.

## Features

- **User Authentication**: Sign up and log in securely with email and password.
- **Role Selection**: Choose your role—Seeker (looking for a room) or Tenant (offering a room).
- **Profile Creation**: Add personal details like name, age, and a bio; Seekers specify preferences, Tenants list property details.
- **Swiping Mechanism**: Swipe left to pass, right to like, or up for a quick profile/listing preview.
- **Matching System**: A match occurs when a Seeker and Tenant mutually swipe right.
- **In-App Chat**: Communicate with matches directly in the app.
- **Filters**: Narrow down options by location, rent price, pet preferences, and more.
- **Role Switching**: Easily switch between Seeker and Tenant roles in settings.
- **Cross-Platform**: Works on both Android and iOS via a single Flutter codebase.


## Technology Stack

- **Frontend**: [Flutter](https://flutter.dev/) (Dart)
- **Backend**: [Firebase](https://firebase.google.com/)
  - **Authentication**: Firebase Auth
  - **Database**: Cloud Firestore
  - **Storage**: Firebase Cloud Storage (for profile pictures and listing photos)
- **Mapping**: [OpenStreetMap](https://www.openstreetmap.org/) with [Nominatim API](https://nominatim.org/) and [flutter_map](https://pub.dev/packages/flutter_map)
- **Emulator**: Android Studio


## Usage

1. **Sign Up**: Create an account with your email and set up a profile.
2. **Choose Role**: Select whether you’re a Seeker or Tenant.
3. **Swipe**: Browse profiles or listings—left to dismiss, right to like, up for details.
4. **Match**: When both parties swipe right, you’re matched and can chat.
5. **Chat**: Use the in-app messaging to arrange details.
6. **Settings**: Switch roles or edit your profile anytime.


## Screenshots
![image](https://github.com/user-attachments/assets/7358b55e-5deb-4258-a0f5-98e55b8a7d61)
![image](https://github.com/user-attachments/assets/78b032d8-87aa-4bb9-8a52-6c9b2dbe30c8)
![image](https://github.com/user-attachments/assets/96e0bd80-5c94-40c7-9e24-1682efad2c74)
![image](https://github.com/user-attachments/assets/61740bc7-41b1-47f2-bde5-e8887ff09a2b)
![image](https://github.com/user-attachments/assets/d4e9394a-c243-4f31-8f79-f169a2ce3da1)
![image](https://github.com/user-attachments/assets/f0b5368a-f6fc-4109-9852-3055a2c5152a)


## Development

- **Version Control**: Managed via GitHub.
- **Testing**:
  - Widget tests for UI components.
  - Manual testing for UX and edge cases.
  - Debugging with Flutter Inspector.
- **Support**: Optimized for phones (compact layout) and tablets (multi-column layout).

## Acknowledgments

- Built as part of the "Design and Implementation of Mobile Applications" course in Politecnico di Milano, with the help of [Marta Pośpiech](https://github.com/MartaPospiech)
