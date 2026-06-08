import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Product {
  String name;
  double price;

  Product({required this.name, required this.price});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Cart App',
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: const CartPage(),
    );
  }
}

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final List<Product> products = [
    Product(name: 'Apple', price: 1.50),
    Product(name: 'Banana', price: 0.80),
    Product(name: 'Orange', price: 1.20),
    Product(name: 'Mango', price: 2.50),
  ];

  final List<Product> cart = [];

  void addToCart(Product product) {
    setState(() {
      cart.add(product);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void showAddItemDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Add New Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final price = double.tryParse(priceController.text.trim());

                if (name.isNotEmpty && price != null) {
                  setState(() {
                    products.add(Product(name: name, price: price));
                  });

                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void showCartDialog() {
    double total = cart.fold(0, (sum, item) => sum + item.price);

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Cart'),
          content: SizedBox(
            width: double.maxFinite,
            child: cart.isEmpty
                ? const Text('Cart is empty')
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...cart.map(
                        (item) => ListTile(
                          title: Text(item.name),
                          trailing: Text('\$${item.price.toStringAsFixed(2)}'),
                        ),
                      ),
                      const Divider(),
                      Text(
                        'Total: \$${total.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Cart App'),
        actions: [
          IconButton(
            onPressed: showCartDialog,
            icon: Badge(
              label: Text('${cart.length}'),
              child: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, index) {
            final product = products[index];

            return Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.shopping_bag,
                      size: 50,
                      color: Colors.blue.shade400,
                    ),
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    ElevatedButton(
                      onPressed: () => addToCart(product),
                      child: const Text('Add to Cart'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddItemDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
