import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase Auth',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blueAccent),
      home: const AuthenticationWrapper(),
    );
  }
}

// class AuthenticationWrapper extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Scaffold(
//             body: Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//         } else if (snapshot.hasData) {
//           return DashboardScreen();
//         } else {
//           return AuthScreen();
//         }
//       },
//     );
//   }
// }
class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({super.key});

  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper>
    with WidgetsBindingObserver {
  bool _isUserSignedIn = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    checkUserSignInStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  void checkUserSignInStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _isUserSignedIn = true;
      });
      startTimer();
    }
  }

  void startTimer() {
    const inactiveDuration = Duration(minutes: 30);
    _timer = Timer(inactiveDuration, () {
      signOutUser();
    });
  }

  void signOutUser() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      _isUserSignedIn = false;
    });
  }

  void onAppForegrounded() {
    if (_isUserSignedIn) {
      startTimer();
    }
  }

  void onAppBackgrounded() {
    _timer?.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      onAppForegrounded();
    } else if (state == AppLifecycleState.paused) {
      onAppBackgrounded();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isUserSignedIn ? const DashboardScreen() : const AuthScreen();
  }
}

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth Screen'),
      ),
      body: SignInScreen(),
    );
  }
}

class SignInScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignInScreen({super.key});

  void signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      emailController.clear();
      passwordController.clear();
      Get.offAll(const DashboardScreen());
    } catch (e) {
      Get.snackbar('Sign In Failed', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void goToSignUp() {
    Get.to(SignUpScreen())!.then((value) {
      if (value != null && value) {
        goToDashboard();
      }
    });
  }

  void goToDashboard() {
    Get.offAll(const DashboardScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
          ),
          const SizedBox(height: 12.0),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
            obscureText: true,
          ),
          const SizedBox(height: 12.0),
          ElevatedButton(
            onPressed: signIn,
            child: const Text('Sign In'),
          ),
          TextButton(
            onPressed: goToSignUp,
            child: const Text('Don\'t have an account? Sign Up'),
          ),
        ],
      ),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignUpScreen({super.key});

  void signUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      emailController.clear();
      passwordController.clear();
      Get.back(result: true);
    } catch (e) {
      Get.snackbar('Sign Up Failed', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void goToSignIn() {
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              onPressed: signUp,
              child: const Text('Sign Up'),
            ),
            TextButton(
              onPressed: goToSignIn,
              child: const Text('Already have an account? Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PurchasedProductsController purchasedProductsController =
      Get.put(PurchasedProductsController());
  final String apiEndpoint =
      'https://winners-world-default-rtdb.firebaseio.com/products.json';
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  void updatePurchaseStatus(Product product) async {
    final apiUrl =
        'https://winners-world-default-rtdb.firebaseio.com/products/${product.id}.json';

    final newStatus = !product.isPurchased; // Toggle the status

    final response = await http.patch(Uri.parse(apiUrl),
        body: json.encode({'isPurchased': newStatus}));

    if (response.statusCode == 200) {
      setState(() {
        product.isPurchased = newStatus;
      });

      if (newStatus) {
        showPurchaseConfirmation(product);
      }
    } else {
      print('Failed to update purchase status. Error: ${response.statusCode}');
    }
  }

  void showPurchaseConfirmation(Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Purchase'),
          content: Text('Do you want to purchase Product ${product.id}?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                // Revert the status back to false
                updatePurchaseStatus(product);
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                updatePurchaseStatus(product);
                purchasedProductsController.purchaseProduct(product);
                // Proceed with the purchase
                // Add your logic here or navigate to the payment process
              },
            ),
          ],
        );
      },
    );
  }

  void _fetchProducts() async {
    final response = await http.get(Uri.parse(apiEndpoint));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>?;
      if (data != null) {
        setState(() {
          products = data.entries.map((entry) {
            final productData = entry.value as Map<String, dynamic>;
            return Product(
              id: entry.key,
              pictureUrl: productData['pictureUrl'] as String,
              price: productData['price'] as int,
              name: productData['name'] as String,
              isPurchased: productData['isPurchased'] as bool? ?? false,
            );
          }).toList();
        });
      }
    } else {
      print('Failed to fetch products. Error: ${response.statusCode}');
    }
  }

//   List<Product> purchasedProducts = [];

//   void purchaseProduct(Product product) {
//   setState(() {
//     if (product.isPurchased) {
//       purchasedProducts.add(product);
//     } else {
//       purchasedProducts.remove(product);
//     }
//   });
// }

  // void showPurchaseBottomSheet(Product product) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (context) {
  //       return Column(
  //         crossAxisAlignment: CrossAxisAlignment.stretch,
  //         children: [
  //           Text('Purchase Product ${product.id}'),
  //           ElevatedButton(
  //             onPressed: () {
  //               purchaseProduct(product);
  //               Navigator.pop(context);
  //             },
  //             child: const Text('Purchase'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(currentUser?.email ?? ''),
              accountEmail: null,
            ),
            ListTile(
              title: const Text('Purchased Products'),
              onTap: () {
                Navigator.pop(context);
                Get.to(() => PurchasedProductsScreen());
              },
            ),
            ListTile(
              title: const Text('Want to sign-in again?'),
              onTap: () {
                Get.offAll(const AuthScreen());
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                //   final isPurchased =
                // purchasedProductsController.purchasedProducts.contains(product);

                return GestureDetector(
                  onTap: () {
                    showPurchaseConfirmation(product);
                  },
                  child: Card(
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Image.network(
                            product.pictureUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product.name!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'Rs: ${product.price.toString()}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showPurchaseConfirmation(product);
                          },
                          child: Text(
                            product.isPurchased ? 'Purchased' : 'Purchase',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                product.isPurchased ? Colors.green : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text('User is signed out. Please sign in again.'),
            );
          }
        },
      ),
    );
  }
}

class PurchasedProductsScreen extends StatefulWidget {
  @override
  State<PurchasedProductsScreen> createState() =>
      _PurchasedProductsScreenState();
}

class _PurchasedProductsScreenState extends State<PurchasedProductsScreen> {
  final PurchasedProductsController purchasedProductsController =
      Get.put(PurchasedProductsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchased Products'),
      ),
      body: ListView.builder(
        itemCount: purchasedProductsController.purchasedProducts.length,
        itemBuilder: (context, index) {
          final product = purchasedProductsController.purchasedProducts[index];

          return ListTile(
            title: Text('Product ${product.name}'),
            leading: Image.network(
              product.pictureUrl,
              width: 50,
              height: 50,
            ),
            subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
          );
        },
      ),
    );
  }
}

class Product {
  final String id;
  final String pictureUrl;
  final int price;
  final String? name;
  bool isPurchased;

  Product({
    required this.id,
    required this.pictureUrl,
    required this.price,
    required this.name,
    this.isPurchased = false,
  });
}

class PurchasedProductsController extends GetxController {
  RxList<Product> purchasedProducts = <Product>[].obs;

  void purchaseProduct(Product product) {
    if (product.isPurchased) {
      purchasedProducts.remove(product);
    } else {
      purchasedProducts.add(product);
    }
  }
}
