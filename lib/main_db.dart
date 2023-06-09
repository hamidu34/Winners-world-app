// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Firebase Auth',
//       theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blueAccent),
//       home: AuthenticationWrapper(),
//     );
//   }
// }

// class AuthenticationWrapper extends StatefulWidget {

//   @override
//   _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
// }

// class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
//   bool _isUserSignedIn = false;

//   @override
//   void initState() {
//     super.initState();
//     checkUserSignInStatus();
//   }

//   void checkUserSignInStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     bool isUserSignedIn = prefs.getBool('isUserSignedIn') ?? false;

//     if (isUserSignedIn) {
//       // If the user is already signed in, fetch the product status for the current user.
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         setState(() {
//           _isUserSignedIn = true;
//         });
//       } else {
//         // User is signed out, update the flag in SharedPreferences
//         await prefs.setBool('isUserSignedIn', false);
//       }
//     }
//   }

//   void signInUser() async {
//     // Perform sign-in logic using FirebaseAuth
//     // ...

//     // If sign-in is successful, update the flag in SharedPreferences
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('isUserSignedIn', true);

//     setState(() {
//       _isUserSignedIn = true;
//     });
//   }

//   void signOutUser() async {
//     await FirebaseAuth.instance.signOut();
//     setState(() {
//       _isUserSignedIn = false;
//     });

//     // Update the flag in SharedPreferences
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('isUserSignedIn', false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _isUserSignedIn ? DashboardScreen() : AuthScreen();
//   }
// }

// class AuthScreen extends StatelessWidget {
//   const AuthScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Auth Screen'),
//       ),
//       body: SignInScreen(),
//     );
//   }
// }

// class SignInScreen extends StatefulWidget {
//   SignInScreen({super.key});

//   @override
//   State<SignInScreen> createState() => _SignInScreenState();
// }

// class _SignInScreenState extends State<SignInScreen> {
//   final TextEditingController emailController = TextEditingController();

//   final TextEditingController passwordController = TextEditingController();
//   bool isUserSignedIn = _AuthenticationWrapperState()._isUserSignedIn;

//   void signIn() async {
//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: emailController.text.trim(),
//         password: passwordController.text.trim(),
//       );

//       // If sign-in is successful, update the flag in SharedPreferences
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setBool('isUserSignedIn', true);

//       setState(() {
//         isUserSignedIn = true;
//       });

//       Get.offAll(() => const DashboardScreen());
//     } catch (e) {
//       Get.snackbar('Sign In Failed', e.toString(),
//           snackPosition: SnackPosition.BOTTOM);
//     }
//   }

//   void goToSignUp() {
//     Get.to(SignUpScreen())!.then((value) {
//       if (value != null && value) {
//         goToDashboard();
//       }
//     });
//   }

//   void goToDashboard() {
//     Get.offAll(const DashboardScreen());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           TextField(
//             controller: emailController,
//             decoration: const InputDecoration(
//               labelText: 'Email',
//             ),
//           ),
//           const SizedBox(height: 12.0),
//           TextField(
//             controller: passwordController,
//             decoration: const InputDecoration(
//               labelText: 'Password',
//             ),
//             obscureText: true,
//           ),
//           const SizedBox(height: 12.0),
//           ElevatedButton(
//             onPressed: signIn,
//             child: const Text('Sign In'),
//           ),
//           TextButton(
//             onPressed: goToSignUp,
//             child: const Text('Don\'t have an account? Sign Up'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class SignUpScreen extends StatelessWidget {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   SignUpScreen({super.key});

//   void signUp() async {
//     try {
//       await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: emailController.text.trim(),
//         password: passwordController.text.trim(),
//       );

//       // If sign-up is successful, update the flag in SharedPreferences
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setBool('isUserSignedIn', true);

//       emailController.clear();
//       passwordController.clear();
//       Get.back(result: true);
//     } catch (e) {
//       Get.snackbar('Sign Up Failed', e.toString(),
//           snackPosition: SnackPosition.BOTTOM);
//     }
//   }

//   void goToSignIn() {
//     Get.back();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: emailController,
//               decoration: const InputDecoration(
//                 labelText: 'Email',
//               ),
//             ),
//             const SizedBox(height: 12.0),
//             TextField(
//               controller: passwordController,
//               decoration: const InputDecoration(
//                 labelText: 'Password',
//               ),
//               obscureText: true,
//             ),
//             const SizedBox(height: 12.0),
//             ElevatedButton(
//               onPressed: signUp,
//               child: const Text('Sign Up'),
//             ),
//             TextButton(
//               onPressed: goToSignIn,
//               child: const Text('Already have an account? Sign In'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});

//   @override
//   _DashboardScreenState createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   final PurchasedProductsController purchasedProductsController =
//       Get.put(PurchasedProductsController());
//   final String apiEndpoint =
//       'https://testing-b606c-default-rtdb.firebaseio.com';
//   List<Product> products = [];
//    final bool _isUserSignedIn = false;

//   @override
//   void initState() {
//     super.initState();
//     _checkUserSignInStatus();
//   }
//   Future<void> _checkUserSignInStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     bool isUserSignedIn = prefs.getBool('isUserSignedIn') ?? false;

//     if (isUserSignedIn) {
//       // If the user is already signed in, fetch the product status for the current user.
//       _fetchProducts();
//     }
//     FirebaseAuth.instance.authStateChanges().listen((user) {
//       if (user != null) {
//         _fetchProducts();
//       }
//     });
//   }

//   Future<void> updatePurchaseStatus(Product product) async {
//     final apiUrl = '$apiEndpoint/products/${product.id}/isPurchased.json';

//     final newStatus = !product.isPurchased; // Toggle the status

//     final response =
//         await http.put(Uri.parse(apiUrl), body: json.encode(newStatus));

//     if (response.statusCode == 200) {
//       setState(() {
//         product.isPurchased = newStatus;
//       });

//       if (newStatus) {
//         showPurchaseConfirmation(product);
//       }
//     } else {
//       print('Failed to update purchase status. Error: ${response.statusCode}');
//     }
//   }

//   void showPurchaseConfirmation(Product product) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Confirm Purchase'),
//           content: Text('Do you want to purchase Product ${product.id}?'),
//           actions: [
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 // Revert the status back to false
//                 setState(() {
//                   product.isPurchased = false;
//                 });
//               },
//             ),
//             TextButton(
//               child: Text('Confirm'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 updatePurchaseStatus(product); // Update the status to true
//                 purchasedProductsController.purchaseProduct(product);
//                 // Proceed with the purchase
//                 // Add your logic here or navigate to the payment process
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

// void _fetchProducts() async {
//   final response = await http.get(Uri.parse('$apiEndpoint/products.json'));
//   if (response.statusCode == 200) {
//     final data = json.decode(response.body) as Map<String, dynamic>?;
//     if (data != null) {
//       final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
//       final userResponse = await http.get(Uri.parse('$apiEndpoint/users/$userId/purchasedProducts.json'));
//       if (userResponse.statusCode == 200) {
//         final userPurchasedProducts = json.decode(userResponse.body) as Map<String, dynamic>?;

//         // Create a local list to store the updated products
//         List<Product> updatedProducts = [];

//         // Iterate over the product entries and update the isPurchased status
//         data.entries.forEach((entry) {
//           final productData = entry.value as Map<String, dynamic>;
//           final isPurchased = userPurchasedProducts?[entry.key] as bool? ?? false;

//           // Create the updated product object and add it to the list
//           updatedProducts.add(Product(
//             id: entry.key,
//             pictureUrl: productData['pictureUrl'] as String,
//             price: productData['price'] as int,
//             name: productData['name'] as String,
//             isPurchased: isPurchased,
//           ));
//         });

//         // Update the products state variable with the updated product list using setState()
//         setState(() {
//           products = updatedProducts;
//         });
//       } else {
//         print('Failed to fetch user purchased products. Error: ${userResponse.statusCode}');
//       }
//     }
//   } else {
//     print('Failed to fetch products. Error: ${response.statusCode}');
//   }

//   // If the user is signed in, update the product status in SharedPreferences
//   if (_isUserSignedIn) {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final userPurchasedProducts = json.decode(prefs.getString('userPurchasedProducts')!) as Map<String, dynamic>?;

//     if (userPurchasedProducts != null) {
//       for (var product in products) {
//         product.isPurchased = userPurchasedProducts[product.id] ?? false;
//       }
//     }
//   }
// }

//   String getCurrentUserId() {
//     final user = FirebaseAuth.instance.currentUser;
//     return user?.uid ??
//         ''; // Return the user ID if available, or an empty string if not authenticated
//   }

//   void purchaseProduct(Product product) async {
//     final userId = getCurrentUserId();
//     final endpoint =
//         '$apiEndpoint/users/$userId/purchasedProducts/${product.id}.json';

//     final response =
//         await http.put(Uri.parse(endpoint), body: json.encode(true));
//     if (response.statusCode == 200) {
//       // Product purchase updated successfully
//       setState(() {
//         product.isPurchased = true;
//       });
//       showPurchaseConfirmation(product);
//     } else {
//       // Failed to update product purchase
//       print('Failed to update product purchase. Error: ${response.statusCode}');
//     }
//   }

//   void signOut() async {
//     await FirebaseAuth.instance.signOut();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Dashboard'),
//         actions: [
//           IconButton(
//             onPressed: signOut,
//             icon: const Icon(Icons.logout),
//           ),
//         ],
//       ),
//       drawer: Drawer(
//         child: StreamBuilder<User?>(
//           stream: FirebaseAuth.instance.authStateChanges(),
//           builder: (context, snapshot) {
//             final User? currentUser = snapshot.data;

//             return ListView(
//               padding: EdgeInsets.zero,
//               children: [
//                 UserAccountsDrawerHeader(
//                   accountName: Text(currentUser?.email ?? ''),
//                   accountEmail: null,
//                 ),
//                 ListTile(
//                   title: const Text('Purchased Products'),
//                   onTap: () {
//                     Get.to(() => PurchasedProductsScreen());
//                   },
//                 ),
//                 currentUser != null
//                     ? const Text('')
//                     : ListTile(
//                         title: const Text('Want to sign-in again?'),
//                         onTap: () {
//                           Get.offAll(() => const AuthScreen());
//                         },
//                       ),
//               ],
//             );
//           },
//         ),
//       ),
//       body: StreamBuilder<User?>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasData) {
//             return GridView.builder(
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 10,
//                 mainAxisSpacing: 10,
//                 childAspectRatio: 0.75,
//               ),
//               itemCount: products.length,
//               itemBuilder: (context, index) {
//                 final product = products[index];
//                 return GestureDetector(
//                   onTap: () {
//                     showPurchaseConfirmation(product);
//                   },
//                   child: Card(
//                     elevation: 4,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         Expanded(
//                           child: Image.network(
//                             product.pictureUrl,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             product.name!,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Text(
//                             'Rs: ${product.price.toString()}',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.green,
//                             ),
//                           ),
//                         ),
//                         ElevatedButton(
//                           onPressed: () {
//                             showPurchaseConfirmation(product);
//                           },
//                           child: Text(
//                             product.isPurchased ? 'Purchased' : 'Purchase',
//                           ),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor:
//                                 product.isPurchased ? Colors.green : null,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           } else {
//             return const Center(
//               child: Text('User is signed out. Please sign in again.'),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// class PurchasedProductsScreen extends StatefulWidget {
//   @override
//   State<PurchasedProductsScreen> createState() =>
//       _PurchasedProductsScreenState();
// }

// class _PurchasedProductsScreenState extends State<PurchasedProductsScreen> {
//   final PurchasedProductsController purchasedProductsController =
//       Get.put(PurchasedProductsController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Purchased Products'),
//       ),
//       body: ListView.builder(
//         itemCount: purchasedProductsController.purchasedProducts.length,
//         itemBuilder: (context, index) {
//           final product = purchasedProductsController.purchasedProducts[index];

//           return ListTile(
//             title: Text('Product ${product.name}'),
//             leading: Image.network(
//               product.pictureUrl,
//               width: 50,
//               height: 50,
//             ),
//             subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
//           );
//         },
//       ),
//     );
//   }
// }

// class PurchasedProductsController extends GetxController {
//   RxList<Product> purchasedProducts = <Product>[].obs;

//   void purchaseProduct(Product product) {
//     if (product.isPurchased) {
//       purchasedProducts.remove(product);
//     } else {
//       purchasedProducts.add(product);
//     }
//   }
// }
// class Product {
//   final String id;
//   final String pictureUrl;
//   final int price;
//   final String? name;
//   bool isPurchased;

//   Product({
//     required this.id,
//     required this.pictureUrl,
//     required this.price,
//     required this.name,
//     this.isPurchased = false,
//   });
// }

// void updatePurchaseStatus(Product product) async {
//   final apiUrl =
//       'https://testing-b606c-default-rtdb.firebaseio.com/products/${product.id}.json';

//   final newStatus = !product.isPurchased; // Toggle the status

//   final response = await http.patch(Uri.parse(apiUrl),
//       body: json.encode({'isPurchased': newStatus}));

//   if (response.statusCode == 200) {
//     setState(() {
//       product.isPurchased = newStatus;
//     });

//     if (newStatus) {
//       showPurchaseConfirmation(product);
//     }
//   } else {
//     print('Failed to update purchase status. Error: ${response.statusCode}');
//   }
// }

// void showPurchaseConfirmation(Product product) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Confirm Purchase'),
//         content: Text('Do you want to purchase Product ${product.id}?'),
//         actions: [
//           TextButton(
//             child: Text('Cancel'),
//             onPressed: () {
//               Navigator.of(context).pop();
//               // Revert the status back to false
//               updatePurchaseStatus(product);
//             },
//           ),
//           TextButton(
//             child: Text('Confirm'),
//             onPressed: () {
//               Navigator.of(context).pop();
//               updatePurchaseStatus(product);
//               purchasedProductsController.purchaseProduct(product);
//               // Proceed with the purchase
//               // Add your logic here or navigate to the payment process
//             },
//           ),
//         ],
//       );
//     },
//   );
// }

// void _fetchProducts() async {
//   final response = await http.get(Uri.parse(apiEndpoint));
//   if (response.statusCode == 200) {
//     final data = json.decode(response.body) as Map<String, dynamic>?;
//     if (data != null) {
//       setState(() {
//         products = data.entries.map((entry) {
//           final productData = entry.value as Map<String, dynamic>;
//           return Product(
//             id: entry.key,
//             pictureUrl: productData['pictureUrl'] as String,
//             price: productData['price'] as int,
//             name: productData['name'] as String,
//             isPurchased: productData['isPurchased'] as bool? ?? false,
//           );
//         }).toList();
//       });
//     }
//   } else {
//     print('Failed to fetch products. Error: ${response.statusCode}');
//   }
// }
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
//   void _fetchProducts() async {
//     final response = await http.get(Uri.parse('$apiEndpoint/products.json'));
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body) as Map<String, dynamic>?;
//       if (data != null) {
//         final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
//         final userResponse = await http.get(
//             Uri.parse('$apiEndpoint/users/$userId/purchasedProducts.json'));
//         if (userResponse.statusCode == 200) {
//           final userPurchasedProducts =
//               json.decode(userResponse.body) as Map<String, dynamic>?;
//           setState(() {
//             products = data.entries.map((entry) {
//               final productData = entry.value as Map<String, dynamic>;
//               final isPurchased =
//                   userPurchasedProducts?[entry.key] as bool? ?? false;
//               return Product(
//                 id: entry.key,
//                 pictureUrl: productData['pictureUrl'] as String,
//                 price: productData['price'] as int,
//                 name: productData['name'] as String,
//                 isPurchased: isPurchased,
//               );
//             }).toList();
//           });
//         } else {
//           print(
//               'Failed to fetch user purchased products. Error: ${userResponse.statusCode}');
//         }
//       }
//     } else {
//       print('Failed to fetch products. Error: ${response.statusCode}');
//     }
//     // If the user is signed in, update the product status in SharedPreferences
// if (_isUserSignedIn) {
//   SharedPreferences prefs = await SharedPreferences.getInstance();

//   final userPurchasedProducts =
//       json.decode(prefs.getString('userPurchasedProducts')!) as Map<String, dynamic>?;

//   if (userPurchasedProducts != null) {
//     products.forEach((product) {
//       product.isPurchased = userPurchasedProducts[product.id] ?? false;
//     });
//   }
// }

//   }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final int price;
  bool purchased;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.purchased,
  });
}

class Users {
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  final Map<String, bool> purchasedProducts;

  Users({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.purchasedProducts,
  });
}

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

class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({super.key});

  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  var isUserSignedIn = false;

  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    checkUserSignInStatus();
  }

  void checkUserSignInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isUserSignedIn = prefs.getBool('isUserSignedIn') ?? false;

    if (isUserSignedIn) {
      // If the user is already signed in, fetch the product status for the current user.
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          isUserSignedIn = true;
        });
      } else {
        // User is signed out, update the flag in SharedPreferences
        await prefs.setBool('isUserSignedIn', false);
      }
    }
  }

  Future<Users?> signInUser(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isUserSignedIn', true);
      isUserSignedIn = true;
      Get.offAll(() => const Dashboard());
      DocumentSnapshot userSnapshot =
          await _usersCollection.doc(userCredential.user!.uid).get();

      if (userSnapshot.exists) {
        Users user = Users(
          id: userSnapshot.id,
          name: userSnapshot.get('name'),
          phoneNumber: userSnapshot.get('phoneNumber'),
          email: userSnapshot.get('email'),
          purchasedProducts:
              Map<String, bool>.from(userSnapshot.get('purchasedProducts')),
        );

        return user;
      }
      // If sign-in is successful, update the flag in SharedPreferences
    } catch (e) {
      Get.snackbar('Sign In Failed', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
    return null;
  }

  Future<Users?> signUpUser(
      String name, String phoneNumber, String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      Users newUser = Users(
        id: userCredential.user!.uid,
        name: name,
        phoneNumber: phoneNumber,
        email: email,
        purchasedProducts: {
          "productId1": true,
          "productId2": false,
          "productId3": true,
        },
      );

      await _usersCollection.doc(userCredential.user!.uid).set({
        'name': newUser.name,
        'phoneNumber': newUser.phoneNumber,
        'email': newUser.email,
        'purchasedProducts': newUser.purchasedProducts,
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isUserSignedIn', true);

      Get.back(result: true);

      return newUser;
    } catch (e) {
      Get.snackbar('Sign Up Failed', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
    return null;
  }

  void signOutUser() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      isUserSignedIn = false;
    });

    // Update the flag in SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isUserSignedIn', false);
  }

  @override
  Widget build(BuildContext context) {
    // isUserSignedIn ? const Dashboard() : AuthScreen();
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return const Dashboard();
        } else {
          return AuthScreen();
        }
      },
    );
  }
}

class AuthScreen extends StatelessWidget {
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
  final _AuthenticationWrapperState _authWrap = _AuthenticationWrapperState();

  void signIn() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    _authWrap.signInUser(email, password);
  }

  void goToSignUp() {
    Get.to(() => SignUpScreen())!.then((value) {
      if (value != null && value) {
        goToDashboard();
      }
    });
  }

  void goToDashboard() {
    Get.offAll(() => const Dashboard());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
          ),
          const SizedBox(height: 12.0),
          TextFormField(
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

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _AuthenticationWrapperState authWrap = _AuthenticationWrapperState();

  Future<void> signUp() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text.trim();
      String phoneNumber = _phoneNumberController.text.trim();
      String email = _emailController.text.trim();
      String password = _passwordController.text;

      authWrap.signUpUser(name, phoneNumber, email, password);
    }
  }

  void goToSignIn() {
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Add additional email validation if desired
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a password';
                  }
                  // Add additional password validation if desired
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
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
      ),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // late Stream<QuerySnapshot> _purchasesStream;
  late String _userName;
  late String _userEmail;

  @override
  void initState() {
    super.initState();
    // _purchasesStream = FirebaseFirestore.instance
    //     .collection('purchases')
    //     .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
    //     .snapshots();

    // Fetch user details
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        final userData = snapshot.data() as Map<String, dynamic>;
        setState(() {
          _userName = userData['name'];
          _userEmail = userData['email'];
        });
      }
    });
  }

  void signOutUser() async {
    await FirebaseAuth.instance.signOut();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isUserSignedIn', false);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _purchasesStream() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('purchases')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  Future<void> updateProductPurchasedStatus(
      String productId, bool newStatus) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final purchaseQuery = FirebaseFirestore.instance
        .collection('purchases')
        .where('userId', isEqualTo: userId)
        .where('productId', isEqualTo: productId);

    final purchaseDocs = await purchaseQuery.get();

    if (purchaseDocs.docs.isNotEmpty) {
      final purchaseDoc = purchaseDocs.docs.first;
      await purchaseDoc.reference.update({'purchased': newStatus});
    } else {
      final purchaseId =
          FirebaseFirestore.instance.collection('purchases').doc().id;
      await FirebaseFirestore.instance
          .collection('purchases')
          .doc(purchaseId)
          .set({
        'purchaseId': purchaseId,
        'userId': userId,
        'productId': productId,
        'purchased': newStatus,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: signOutUser,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: Drawer(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _purchasesStream(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              return Text('Error');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final purchasesDocs = snapshot.data!.docs;

            return Column(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(_userName ?? 'N/A'),
                  accountEmail: Text(_userEmail ?? 'N/A'),
                ),
                if (purchasesDocs.isNotEmpty)
                  ListTile(
                    title: Text('Latest Purchase'),
                    subtitle: Text('Product ID: ${purchasesDocs.last.id}'),
                  ),
              ],
            );
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Product> products = snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return Product(
              id: doc.id,
              name: data['name'],
              description: data['description'],
              price: data['price'],
              purchased: data['purchased'],
            );
          }).toList();

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              Product product = products[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text(product.description),
                trailing: product.purchased ? const Icon(Icons.check) : null,
                onTap: () async {
                  bool newPurchasedStatus = !product.purchased;
                  await updateProductPurchasedStatus(
                      product.id, newPurchasedStatus);
                },
              );
            },
          );
        },
      ),
    );
  }
}


// class Dashboard extends StatefulWidget {
//   const Dashboard({super.key});

//   @override
//   State<Dashboard> createState() => _DashboardState();
// }

// class _DashboardState extends State<Dashboard> {
//   late Stream<DocumentSnapshot> _userStream;

//   @override
//   void initState() {
//     super.initState();
//     _userStream = FirebaseFirestore.instance
//         .collection('users')
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .snapshots();
//   }

//   void signOutUser() async {
//     await FirebaseAuth.instance.signOut();
//     // setState(() {
//     //   isUserSignedIn = false;
//     // });

//     // Update the flag in SharedPreferences
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('isUserSignedIn', false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Dashboard'), actions: [
//         IconButton(onPressed: signOutUser, icon: const Icon(Icons.logout))
//       ]),
//       drawer: Drawer(
//         child: StreamBuilder<DocumentSnapshot>(
//           stream: _userStream,
//           builder:
//               (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//             if (snapshot.hasError) {
//               return const Text('Error');
//             }

//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             if (!snapshot.hasData || !snapshot.data!.exists) {
//               return const Text('User not found');
//             }

//             final userData = snapshot.data!.data() as Map<String, dynamic>?;

//             final userName = userData?['name'];
//             final userEmail = userData?['email'];

//             return Column(
//               children: [
//                 UserAccountsDrawerHeader(
//                   accountName: Text(userName ?? 'N/A'),
//                   accountEmail: Text(userEmail ?? 'N/A'),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('products').snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           List<Product> products = snapshot.data!.docs.map((doc) {
//             Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//             return Product(
//               id: doc.id,
//               name: data['name'],
//               description: data['description'],
//               price: data['price'],
//               purchased: data['purchased'],
//             );
//           }).toList();

//           return ListView.builder(
//             itemCount: products.length,
//             itemBuilder: (BuildContext context, int index) {
//               Product product = products[index];
//               return ListTile(
//                 title: Text(product.name),
//                 subtitle: Text(product.description),
//                 trailing: product.purchased ? const Icon(Icons.check) : null,
//                 onTap: () {
//                   bool newPurchasedStatus = !product.purchased;
//                   FirebaseFirestore.instance
//                       .collection('products')
//                       .doc(product.id)
//                       .update(
//                     {'purchased': newPurchasedStatus},
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
// 