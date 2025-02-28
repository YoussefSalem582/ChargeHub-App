import 'package:chargehub/pages/splachScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/logic.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<EVBloc>(
            create: (context) => EVBloc()..add(FetchStationsEvent()), // Initialize with an event to fetch stations
          ),
        ],
        child: const evApp(),
      ),
    );
  } catch (e) {
    print("Error initializing Firebase: $e");
  }
}

class evApp extends StatelessWidget {
  const evApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // Start at the Login screen
    );
  }
}
