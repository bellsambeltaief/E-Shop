import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_shop/providers/p_products.dart';

/// Le widget du Panier du l'utilisateur
class ShoppingCart extends StatelessWidget {
  const ShoppingCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartItems = Provider.of<PProducts>(context).cartItems;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.withOpacity(0.1),
        title: const Text(
          'Shopping Cart',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];

                // Check if any of the required fields are null
                if (item['thumbnail'] == null || item['title'] == null || item['price'] == null) {
                  return const SizedBox();
                }

                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Center(
                          child: Image.network(
                            item['thumbnail'] as String, // Cast to String to avoid null error
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          item['title'] as String, // Cast to String to avoid null error
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 8),
                        child: Text('\$${item['price']}'), // Display price as String
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          Provider.of<PProducts>(context, listen: false).removeFromCart(index);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
