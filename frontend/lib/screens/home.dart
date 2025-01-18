import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For decoding the response
import '../../widgets/navbar.dart';
 // Import the NewScreen.dart file

class HomeScreen extends StatefulWidget {
  final String username;
  final String userId;

  HomeScreen({required this.username, required this.userId});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> soldProducts = []; // Products with 'Sold' status
  List<dynamic> forSaleProducts = []; // Products with 'Active' status
  bool isLoading = true; // Loading state
  String errorMessage = ''; // Error message for fetching issues

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:5000/products?status=All')); // Replace with actual backend URL
      if (response.statusCode == 200) {
        final products = json.decode(response.body);
        setState(() {
          // Filter products by status
          soldProducts = products.where((product) => product['status'] == 'Sold').toList();
          forSaleProducts = products.where((product) => product['status'] == 'Active').toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load products. Status code: ${response.statusCode}');
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Error fetching products: $error';
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts(); // Fetch products on screen load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: NavBar(
          username: widget.username,
          userId: widget.userId,
        ),
      ),
      // Set background color of the entire page to brown
      body: Container(
        color: Colors.brown[100], // Set the background color to brown
        child: isLoading
            ? Center(child: CircularProgressIndicator()) // Show loading indicator
            : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage)) // Show error message if any
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        // Background image with title
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: Opacity(
                                opacity: 0.7,
                                child: Image.asset(
                                  'assets/old_car.jpg', // Ensure this file exists
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "Welcome to Timeless Treasures! Explore vintage gems and place your bids to make these treasures yours!",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(blurRadius: 10.0, color: Colors.black, offset: Offset(2.0, 2.0)),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        // Sold Products Section
                        _buildProductGridWrapper("Sold Products", soldProducts, "Sold"),
                        // Products for Sale Section
                        _buildProductGridWrapper("Products for Sale", forSaleProducts, "Active"),
                      ],
                    ),
                  ),
      ),
    );
  }

  // Widget to display product grid within a separate card with gradient background
  Widget _buildProductGridWrapper(String sectionTitle, List<dynamic> products, String status) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.transparent, // Make the card transparent so gradient is visible
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade300, const Color.fromARGB(255, 148, 85, 8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section title
              Text(
                sectionTitle,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              // Product grid with horizontal scroll
              _buildProductGrid(products, status),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to display product grid with horizontal scrolling
  Widget _buildProductGrid(List<dynamic> products, String status) {
    if (products.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            status == "Sold" ? 'No sold products available.' : 'No active products for sale.',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Enable horizontal scrolling only
      child: Row(
        children: products.map((product) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0), // Space between cards
            width: 200, // Fixed width for product card
            child: _buildProductCard(product, status,),
          );
        }).toList(),
      ),
    );
  }

  // Widget to display individual product card with fixed size
  Widget _buildProductCard(dynamic product, String status) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white,
      shadowColor: Colors.brown[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Product image with rounded corners at the top
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(
              product['product_image'].startsWith('http')
                  ? product['product_image']
                  : 'http://127.0.0.1:5000/images/${product['product_image']}', // Adjust if image is a file name
              width: 200, // Fixed width
              height: 150, // Fixed height
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[300],
                child: Icon(Icons.image_not_supported, size: 80, color: Colors.grey[700]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // Product name with bold styling
                Text(
                  product['product_name'],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.brown[800],
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6),
                // Product ID in smaller text
                Text(
                  "Product ID: ${product['product_id']}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                // Status with color coding
                Text(
                  "Status: $status",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: status == "Sold" ? Colors.redAccent : Colors.green[700],
                  ),
                ),
                if (status == "Active") ...[
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (product.containsKey('product_id')) {
                      } else {
                        print('Product ID not found');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 15, 223, 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 6,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: Text(
                      'BID',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
