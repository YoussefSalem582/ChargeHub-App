import 'package:flutter/material.dart';
import '../evHomePage.dart';
import 'evCars.dart';
import 'gasCars.dart';

class carGalleryPage extends StatelessWidget {
  const carGalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(31, 2, 75, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(31, 2, 75, 1),
        title:
            const Text('Car Collection', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const HomePage(
                  username: 'back to HomePage',
                ), // Navigate to CarGalleryPage
              ),
            ); // Go back to the previous page
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            // First button for EV Cars
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          evCarsPage(), // Navigate to EVCarsPage
                    ),
                  );
                },
                child: SizedBox(
                  width: double.infinity,
                  height: 250, // Set equal height for both buttons
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        'assets/images/evCar.png',
                        // Replace with your EV cars image
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40), // Adjust spacing between images

            // Second button for Gas Cars
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          gasCarsPage(), // Navigate to GasCarsPage
                    ),
                  );
                },
                child: SizedBox(
                  width: double.infinity,
                  height: 250, // Set equal height for both buttons
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(51, 49, 48, 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        'assets/images/gasCar.png',
                        // Replace with your Gas cars image
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
