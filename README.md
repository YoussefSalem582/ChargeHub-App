# ChargeHub - EV & Gas Station Locator 🚗⚡

A Flutter-based mobile app for locating EV charging stations and gas stations, featuring user authentication, interactive maps, and a car gallery. Built with Firebase, Bloc state management, and FlutterMap.

## Features ✨

- **Splash Screen**: Smooth transition to the login screen.
- **User Authentication**: Secure login/signup using Firebase Auth.
- **Interactive Map**: 
  - View EV/gas stations with custom markers.
  - Add new stations (name, type, charging speed).
  - Zoom controls and station details popup.
- **Car Gallery**: Browse EV and gas car collections.
- **State Management**: Uses `flutter_bloc` for fetching/adding stations.
- **Responsive UI**: Consistent styling across all screens.

## Installation 🛠️

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/chargehub.git
   cd chargehub
   ```

2. **Set up Firebase**:
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/).
   - Enable Email/Password authentication.
   - Replace `firebase_options.dart` with your project's configuration.

3. **Install dependencies**:
   ```bash
   flutter pub get
   ```

4. **Add assets**:
   - Place images in `assets/images/` (e.g., `chargeHub.png`, `map.png`).

5. **Run the app**:
   ```bash
   flutter run
   ```

## Dependencies 📦

- `firebase_core: ^2.18.0`
- `firebase_auth: ^4.11.1`
- `flutter_bloc: ^8.1.3`
- `flutter_map: ^5.0.0`
- `latlong2: ^0.8.1`

## Usage 🚀

1. **Sign Up/Login**:  
   ![Auth Screens](https://via.placeholder.com/300x600?text=Login/Signup+Screen)

2. **Home Page**:  
   - Access the map or car gallery via buttons or the app menu.  
   ![Home](https://via.placeholder.com/300x600?text=Home+Screen)

3. **Map Screen**:  
   - Tap anywhere to add a station.  
   - Tap markers to view details.  
   ![Map](https://via.placeholder.com/300x600?text=Map+Screen)

4. **Car Gallery**:  
   - Browse EV/gas cars.  
   ![Gallery](https://via.placeholder.com/300x600?text=Car+Gallery)

## Contributing 🤝

1. Fork the project.
2. Create a feature branch (`git checkout -b feature/amazing-feature`).
3. Commit changes (`git commit -m 'Add amazing feature'`).
4. Push to the branch (`git push origin feature/amazing-feature`).
5. Open a Pull Request.
