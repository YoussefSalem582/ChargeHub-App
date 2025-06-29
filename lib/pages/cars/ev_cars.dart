import 'package:flutter/material.dart';
import '../map_screen.dart';
import '../splash_screen.dart';
import 'cars.dart';

class EvCarsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(31, 2, 75, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(31, 2, 75, 1),
        title: const Text(
          'EV Cars Collection',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const CarGalleryPage()),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 1.5,
          ),
          itemCount: _carImages.length,
          itemBuilder: (context, index) {
            final car = _carImages[index];
            return GestureDetector(
              onTap: () {
                _showCarDetailsDialog(context, car);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(car['imagePath']!, fit: BoxFit.cover),
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

  final List<Map<String, String>> _carImages = [
    {'name': 'BMW i4', 'imagePath': 'assets/images/evCar/BMW i4.jpg'},
    {
      'name': 'FORD Mustang',
      'imagePath': 'assets/images/evCar/ford mustang.jpg',
    },
    {
      'name': 'Tesla Model Y',
      'imagePath': 'assets/images/evCar/Tesla model y.jpeg',
    },
    {
      'name': 'Tesla Model 3',
      'imagePath': 'assets/images/evCar/Tesla model3.jpeg',
    },
    {
      'name': 'Tesla Model S',
      'imagePath': 'assets/images/evCar/TESLA-MOTORS-Model-S-4693_64.jpg',
    },
    {
      'name': 'Tesla Model X',
      'imagePath': 'assets/images/evCar/tesla model x.jpeg',
    },
  ];

  void _showCarDetailsDialog(BuildContext context, Map<String, String> car) {
    String details = '';
    String quote = '';

    switch (car['name']) {
      case 'BMW i4':
        details =
            'The BMW i4 combines luxury and electric power, delivering a sporty and efficient ride. It offers a sleek design and advanced technology features.';
        quote = '"The BMW i4 is the epitome of modern luxury and performance."';
        break;
      case 'FORD Mustang':
        details =
            'The FORD Mustang Mach-E is a high-performance electric SUV with classic Mustang styling. It provides a thrilling driving experience with cutting-edge tech.';
        quote =
            '"The Mustang Mach-E offers an exhilarating drive while being environmentally conscious."';
        break;
      case 'Tesla Model Y':
        details =
            'The Tesla Model Y is a versatile electric crossover that combines efficiency with spaciousness. It features advanced autopilot capabilities and impressive range.';
        quote =
            '"The Model Y brings Tesla\'s innovation to a new level of versatility."';
        break;
      case 'Tesla Model 3':
        details =
            'The Tesla Model 3 is a popular electric sedan known for its range, performance, and affordability. It offers a minimalist interior and cutting-edge technology.';
        quote =
            '"The Model 3 is a game-changer in the electric vehicle market."';
        break;
      case 'Tesla Model S':
        details =
            'The Tesla Model S is a luxury electric sedan with high performance and a long range. It boasts a sleek design, high-tech features, and impressive acceleration.';
        quote =
            '"The Model S represents the pinnacle of electric vehicle engineering."';
        break;
      case 'Tesla Model X':
        details =
            'The Tesla Model X is an electric SUV known for its distinctive falcon-wing doors and advanced technology. It offers a spacious interior and exceptional range.';
        quote = '"The Model X redefines what an electric SUV can be."';
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
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
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
                  style: const TextStyle(
                    color: Colors.tealAccent,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.tealAccent),
              ),
            ),
          ],
        );
      },
    );
  }
}
