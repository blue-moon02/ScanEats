# ScanEats: Your Nutrition Companion 🍏

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

ScanEats is a mobile app built with Flutter that empowers users to make informed food choices by scanning product barcodes and accessing detailed nutritional information.

## Features 🚀

* **Barcode Scanning:** Quickly scan product barcodes to retrieve detailed information.
* **Nutritional Information:** Access comprehensive data on calories, nutrients, ingredients, and allergens.
* **Personalized History:** Track your scanned products and view your nutrition history.
* **Search Functionality:** Search for products by name or EAN code.
* **User Authentication (Firebase):** Securely create an account and log in to personalize your experience.
* **Data Storage (Firebase Firestore):** Store scanned product history and user data in the cloud.
* **Image Storage (Firebase Storage):** Store images of barcodes and ingredient lists.

## Getting Started 🛠️

### Prerequisites

* Flutter SDK: Follow the official [Flutter installation guide](https://flutter.dev/docs/get-started/install).
* Firebase Project: Create a Firebase project and enable the following services:
    * Authentication
    * Firestore
    * Storage
* Android Studio or VS Code: Install your preferred IDE with the Flutter and Dart plugins.

### Installation

1. Clone this repository: `git clone https://github.com/your-username/label_scanner.git`
2. Navigate to the project directory: `cd label_scanner`
3. Install dependencies: `flutter pub get`
4. Set up Firebase:
   - Follow the instructions in the Firebase console to add your Android and/or iOS app to your project.
   - Download the configuration files (`google-services.json` for Android, `GoogleService-Info.plist` for iOS) and place them in the appropriate directories.
   - Set up your environment variables or other secure mechanisms to store your Firebase API keys.
5. Run the app: `flutter run`

## Screenshots 📸

[Include screenshots or GIFs of your app's key features here]


## License 📄

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## Acknowledgements 🙏

* Flutter community for the awesome framework.
* Open Food Facts for their comprehensive product data.
* Firebase for providing the backend services.


## Contact 📧

Feel free to reach out if you have any questions or feedback!

[Krishnakant Chouhan/chouhan1302@gmail.com]


A few resources to get you started if you want to make Flutter projects:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.