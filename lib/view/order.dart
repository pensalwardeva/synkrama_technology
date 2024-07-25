import 'package:flutter/material.dart';

class OrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Page'),
        centerTitle: true,
        backgroundColor: Colors.black26,
      ),
      body: Center(
        child: Text('This is the Order Page'),
      ),
    );
  }
}
