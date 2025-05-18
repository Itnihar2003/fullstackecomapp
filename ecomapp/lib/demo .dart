import 'package:flutter/material.dart';


class ParlourApp extends StatelessWidget {
  const ParlourApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parlour App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
        fontFamily: 'Inria Serif',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
          bodySmall: TextStyle(fontSize: 12),
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          titleSmall: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top login section with logo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo placeholder
                    const FlutterLogo(size: 50),
                    
                    // Login button
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF444444),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Text(
                        'login',
                        style: textTheme.bodySmall?.copyWith(color: Colors.white),
                      ),
                    ),
                    
                    // App icon placeholder
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.white),
                      ),
                      child: const Icon(
                        Icons.spa_outlined,
                        size: 30,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Banner image with shadow
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFF1E1E1E),
                      offset: Offset(-3, 4),
                      blurRadius: 6.9,
                    ),
                  ],
                ),
                // Demo image placeholder for banner
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Image.network(
                    'https://picsum.photos/600/300',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.image, size: 60, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
              
              // Best Services section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Best Services :',
                      style: textTheme.titleLarge?.copyWith(
                        color: const Color(0xFF1E1E1E),
                      ),
                    ),
                    Text(
                      'View all ',
                      style: textTheme.titleSmall?.copyWith(
                        color: Colors.red[700],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Services horizontal scroll
              SizedBox(
                height: 180,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  children: [
                    _buildServiceItem('https://picsum.photos/400/200?random=1'),
                    _buildServiceItem('https://picsum.photos/400/200?random=2'),
                    _buildServiceItem('https://picsum.photos/400/200?random=3'),
                  ],
                ),
              ),
              
              // Categories section title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Explore our category :',
                      style: textTheme.titleLarge?.copyWith(
                        color: const Color(0xFF1E1E1E),
                      ),
                    ),
                    Text(
                      'View all ',
                      style: textTheme.titleSmall?.copyWith(
                        color: Colors.red[700],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Categories row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCategoryItem('https://picsum.photos/100?random=4', 'Hair', textTheme),
                    _buildCategoryItem('https://picsum.photos/100?random=5', 'Haircut\nstyling', textTheme),
                    _buildCategoryItem('https://picsum.photos/100?random=6', 'Radient', textTheme),
                    _buildCategoryItem('https://picsum.photos/100?random=7', 'Beard', textTheme),
                  ],
                ),
              ),
              
              // Category image
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.09),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Center(
                  child: Image.network(
                    'https://picsum.photos/500/300?random=8',
                    height: 150,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 150,
                      width: 250,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.image, size: 60, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildServiceItem(String imageUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      // Network image with error handling
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[300],
            child: const Center(
              child: Icon(Icons.image, size: 60, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildCategoryItem(String imageUrl, String title, TextTheme textTheme) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black),
          ),
          // Circle image with error handling
          child: ClipOval(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[300],
                child: const Icon(Icons.person, size: 40, color: Colors.grey),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: textTheme.titleSmall?.copyWith(
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}