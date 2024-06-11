import 'package:e_shop/services/firebase_auth_service.dart';
import 'package:e_shop/widgets/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:e_shop/providers/p_products.dart';
import 'package:provider/provider.dart';
import 'package:e_shop/widgets/product_details.dart';
import 'package:e_shop/widgets/shopping_cart.dart';
import 'package:e_shop/models/m_products.dart';
import 'package:badges/badges.dart';
import 'package:badges/badges.dart' as badges;

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<PProducts>(context);
    final firebaseAuthService = FirebaseAuthService();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                firebaseAuthService.logOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignIn(),
                  ),
                );
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.deepPurple,
              ),
            ),
          ],
          title: const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              'E-SHOP',
              style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.w600,
                fontSize: 26,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      flex: 3,
                      child: Text(
                        'Find joy in every purchase',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Consumer<PProducts>(
                        builder: (context, productProvider, _) => badges.Badge(
                          position: BadgePosition.topEnd(
                            top: 1,
                            end: 1,
                          ),
                          badgeContent: Text(
                            productProvider.cartItems.length.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ShoppingCart(),
                                ),
                              );
                            },
                            icon: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: Icon(
                                Icons.shopping_cart,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(50),
                    ),
                    color: Colors.deepPurple.withOpacity(0.1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Search by Name',
                        suffixIcon: InkWell(
                          onTap: () {
                            productProvider.filterProducts(
                              productProvider.searchQuery,
                              productProvider.currentRangeValues,
                            );
                          },
                          child: const Icon(
                            Icons.search,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        productProvider.filterProducts(
                          value,
                          productProvider.currentRangeValues,
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: RangeSlider(
                  values: productProvider.currentRangeValues,
                  min: productProvider.minPrice,
                  max: productProvider.maxPrice,
                  divisions: 20,
                  labels: RangeLabels(
                    productProvider.currentRangeValues.start.round().toString(),
                    productProvider.currentRangeValues.end.round().toString(),
                  ),
                  onChanged: (values) {
                    productProvider.filterProducts(
                      productProvider.searchQuery,
                      values,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                child: FutureBuilder<List<MProducts>>(
                  future: MProducts.fetchAllProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No products found'),
                      );
                    } else {
                      final List<MProducts> filteredProducts = snapshot.data!.where((product) {
                        final bool nameMatch =
                            product.title.toLowerCase().contains(productProvider.searchQuery.toLowerCase());
                        final bool priceMatch = product.price >= productProvider.currentRangeValues.start &&
                            product.price <= productProvider.currentRangeValues.end;
                        return nameMatch && priceMatch;
                      }).toList();

                      return GridView.builder(
                        controller: _scrollController,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          var product = filteredProducts[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetails(
                                    product: product,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Image.network(
                                        product.thumbnail,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    child: Text(
                                      product.title,
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8,
                                      bottom: 8,
                                    ),
                                    child: Text(
                                      '\$${product.price}',
                                    ),
                                  ),
                                  _buildBadge(product),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildBadge(MProducts product) {
  double price = product.price;
  var discountPercentage = product.discountPercentage;
  String createdAtStr = product.createdAt;
  DateTime createdAt = createdAtStr.isNotEmpty ? DateTime.parse(createdAtStr) : DateTime.now();
  bool isNew = DateTime.now().difference(createdAt).inDays <= 3;

  List<Widget> badges = [];

  if (price < 10) {
    badges.add(
      _badge(
        'Vente Flash',
        Colors.black,
      ),
    );
  }

  if (price < 50) {
    badges.add(
      _badge(
        '$discountPercentage% off',
        Colors.green,
      ),
    );
  }

  if (isNew) {
    badges.add(
      _badge(
        'Nouveau',
        Colors.purple,
      ),
    );
  }

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: badges,
      ),
    ),
  );
}

Widget _badge(String text, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 3,
    ),
    margin: const EdgeInsets.only(right: 4),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
      ),
    ),
  );
}
