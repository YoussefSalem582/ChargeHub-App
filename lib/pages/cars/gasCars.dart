import 'package:flutter/material.dart';
import '../mapScreen.dart';
import '../splachScreen.dart';
import 'cars.dart';

class gasCarsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(31, 2, 75, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(31, 2, 75, 1),
        title: const Text('Gas Cars Collection', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => carGalleryPage(), // Navigate to CarGalleryPage
              ),
            );
          },
        ),
        actions: [
          PopupMenuButton<String>(
            color: const Color.fromRGBO(31, 2, 75, 0.6),
            icon: const Icon(Icons.menu, color: Colors.white),
            onSelected: (value) {
              switch (value) {
                case 'Map':
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MapScreen(),
                    ),
                  );
                  break;
                case 'Cars':
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => carGalleryPage(),
                    ),
                  );
                  break;
                case 'Log out':
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          SplashScreen(), // Replace with your actual SignupPage class
                    ),
                  );
                  break;
              }
            },
            itemBuilder: (context) => [
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
                child: Text('Log out ', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 1.5,
          ),
          itemCount: _gasCarImages.length,
          itemBuilder: (context, index) {
            final car = _gasCarImages[index];
            return GestureDetector(
              onTap: () {
                _showCarDetailsDialog(context, car);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      car['imagePath']!,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        color: Colors.black54,
                        child: Text(
                          car['name']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  final List<Map<String, String>> _gasCarImages = [
    {'name': 'Ferrari 488', 'imagePath': 'assets/images/gasCar/ferrari_488.jpeg'},
    {'name': 'Lamborghini Aventador', 'imagePath': 'assets/images/gasCar/lamborghini_aventador.jpeg'},
    {'name': 'Porsche 911', 'imagePath': 'assets/images/gasCar/porsche_911.jpeg'},
    {'name': 'Chevrolet Camaro', 'imagePath': 'assets/images/gasCar/chevrolet_camaro.jpeg'},
    {'name': 'Ford GT', 'imagePath': 'assets/images/gasCar/ford_gt.jpeg'},
    {'name': 'Dodge Challenger', 'imagePath': 'assets/images/gasCar/dodge_challenger.jpeg'},
  ];

  void _showCarDetailsDialog(BuildContext context, Map<String, String> car) {
    String details = '';
    String quote = '';

    switch (car['name']) {
      case 'Ferrari 488':
        details = 'The Ferrari 488 is a high-performance sports car known for its speed and precision. It features a turbocharged V8 engine and cutting-edge aerodynamics.';
        quote = '"The Ferrari 488 is a pure adrenaline rush on wheels."';
        break;
      case 'Lamborghini Aventador':
        details = 'The Lamborghini Aventador is a powerful supercar that delivers exhilarating performance. It boasts a V12 engine and an iconic design.';
        quote = '"The Aventador is the ultimate statement of power and luxury."';
        break;
      case 'Porsche 911':
        details = 'The Porsche 911 is a legendary sports car that combines style, performance, and heritage. It is known for its precision handling and timeless design.';
        quote = '"The Porsche 911 defines the art of driving."';
        break;
      case 'Chevrolet Camaro':
        details = 'The Chevrolet Camaro is a muscle car that blends aggressive looks with impressive performance. It features a range of powerful engine options.';
        quote = '"The Camaro is all about bold performance and American muscle."';
        break;
      case 'Ford GT':
        details = 'The Ford GT is a high-performance supercar inspired by Ford’s racing legacy. It offers breathtaking speed, advanced aerodynamics, and exclusivity.';
        quote = '"The Ford GT is a race car made for the streets."';
        break;
      case 'Dodge Challenger':
        details = 'The Dodge Challenger is a classic American muscle car with powerful V8 engines. It blends retro design with modern performance and technology.';
        quote = '"The Challenger roars with pure American muscle."';
        break;
      default:
        details = 'No details available for this car.';
        quote = 'No quote available.';
        break;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(34, 37, 45, 1),
          title: Text(
            car['name']!,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    car['imagePath']!,
                    fit: BoxFit.cover,
                    height: 200,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  details,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 16),
                Text(
                  quote,
                  style: const TextStyle(color: Colors.tealAccent, fontSize: 14, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close', style: TextStyle(color: Colors.tealAccent)),
            ),
          ],
        );
      },
    );
  }
}
