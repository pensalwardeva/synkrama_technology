import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synkrama_technology/view/order.dart';
import 'package:synkrama_technology/view/profile.dart';
import 'package:synkrama_technology/view/sign_in.dart';
import '../controller/auth_controller.dart';


class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  String? userName;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? 'User';
    });
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
      // Home tab (optional: you can navigate to a specific home page if needed)
        setState(() {
          _selectedIndex = index;
        });
        break;
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => OrderPage()),
        );        break;
      case 2:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );        break;
      default:
        setState(() {
          _selectedIndex = index;
        });
        break;
    }
  }

  Future<void> _logout() async {
    // Clear user data and logout
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await Provider.of<AuthController>(context, listen: false).logout();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => MyLogin()),
    );  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.black26,
        leading: null,
        actions: [
          IconButton(
            icon: Icon(Icons.logout), // Example icon
            onPressed: _logout,
          ),
          SizedBox(width: 16), // Adds space between the buttons
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Welcome, ${userName ?? 'User'}!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: "List 1"),
              Tab(text: "List 2"),
              Tab(text: "List 3"),
            ],
            labelColor: Colors.black,
            indicatorColor: Colors.blue,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildHorizontalList(),
                _buildVerticalList(),
                _buildGridView(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildHorizontalList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            clipBehavior: Clip.antiAlias,
            elevation: 5.0,
            child: Image.network(
              'https://picsum.photos/seed/picsum/200/300',
              width: 150,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  Widget _buildVerticalList() {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          height: 200,
          margin: EdgeInsets.all(8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            clipBehavior: Clip.antiAlias,
            elevation: 5.0,
            child: Image.network(
              'https://picsum.photos/seed/picsum/150/200',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          clipBehavior: Clip.antiAlias,
          elevation: 5.0,
          child: Image.network(
            'https://picsum.photos/seed/picsum/200/200',
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
