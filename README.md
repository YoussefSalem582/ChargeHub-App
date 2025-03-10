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
<img src="https://github.com/user-attachments/assets/4ceeb0e2-b7f1-444e-8298-68bc65e5378e" width="300" height="600">
<img src="https://github.com/user-attachments/assets/7429e884-e7a1-4aba-a9e0-00281dcb2f25" width="300" height="600">

3. **Home Page**:  
   - Access the map or car gallery via buttons or the app menu.
   <img src="https://github.com/user-attachments/assets/1700f76d-139f-4cd0-b3b7-c4c6d2c57d53" width="300" height="600">

4. **Map Screen**:  
   - Tap anywhere to add a station.  
   - Tap markers to view details.
   <img src="https://github.com/user-attachments/assets/5eabe59f-8b1f-4003-b812-1f9be0296ad8" width="300" height="600">

5. **Car Gallery**:  
   - Browse EV/gas cars.  
   <img src="https://github.com/user-attachments/assets/c0175616-140a-4a5b-8e7a-e5ac940739e4" width="300" height="600">

   - EV cars
   <img src="https://github.com/user-attachments/assets/02c60054-4311-4ba1-bd3c-b72e765b43d4" width="300" height="600">
   <img src="https://github.com/user-attachments/assets/7f9a33ef-93fb-450c-98c6-442b6da8968b" width="300" height="600">

   - Gas cars
   <img src="https://github.com/user-attachments/assets/3f9b8926-2e7d-4427-875d-c610709036c6" width="300" height="600">
   <img src="https://github.com/user-attachments/assets/33e3c092-9c9f-41ca-839b-ab7e37b4b217" width="300" height="600">



## Contributing 🤝

1. Fork the project.
2. Create a feature branch (`git checkout -b feature/amazing-feature`).
3. Commit changes (`git commit -m 'Add amazing feature'`).
4. Push to the branch (`git push origin feature/amazing-feature`).
5. Open a Pull Request.
