import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:winners_world_app/screens/welcome_screen.dart';

class Dashboard extends StatefulWidget {
  final String useremail;
  const Dashboard({super.key, required this.useremail});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  final List<Widget> _widgetOption = [
    const Center(child: Text('Home')),
    const Center(child: Text('Tickets')),
    WelcomePage(),
    const Center(child: Text('Profile')),
  ];
  void _onTapItems(int index) {
    setState(() {
      HapticFeedback.selectionClick();
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('WINNER\'s WORLD'),
        centerTitle: true,
      ),
      key: scaffoldKey,
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              const Gap(20),
              Container(
                width: w,
                height: h * 0.2,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('img/rupee.png'),
                  ),
                ),
              ),
              const Gap(20),
              Text(widget.useremail),
            ],
          ),
        ),
      ),
      body: _widgetOption[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        currentIndex: _selectedIndex,
        onTap: _onTapItems,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
        ],
      ),
    );
  }
}
