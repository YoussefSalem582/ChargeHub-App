import 'login.dart';
import 'splash_screen.dart';
import 'package:flutter/material.dart';
import 'cars/cars.dart';
import 'map_screen.dart';

class HomePage extends StatelessWidget {
  final String username;

  const HomePage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(31, 2, 75, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(31, 2, 75, 1.0),
        title: Text(
          'Welcome $username',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => const Login()));
          },
        ),
        actions: [
          PopupMenuButton<String>(
            color: const Color.fromRGBO(31, 2, 75, 0.6),
            icon: const Icon(Icons.menu, color: Colors.white),
            onSelected: (value) {
              switch (value) {
                case 'Map':
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (context) => MapScreen()));
                  break;
                case 'Cars':
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CarGalleryPage(),
                    ),
                  );
                  break;
                case 'Log out':
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SplashScreen(),
                    ),
                  );
                  break;
              }
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem<String>(
                    value: 'Map',
                    child: Text('Map', style: TextStyle(color: Colors.white)),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Cars',
                    child: Text('Cars', style: TextStyle(color: Colors.white)),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Log out',
                    child: Text(
                      'Log out',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            GestureDetector(
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => MapScreen()));
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        'assets/images/map.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CarGalleryPage(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(51, 49, 48, 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        'assets/images/carList.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
