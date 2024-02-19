import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
class PassDataDemo extends StatefulWidget {
  const PassDataDemo({Key? key}) : super(key: key);
  @override
  State<PassDataDemo> createState() => _PassDataDemoState();
}
class _PassDataDemoState extends State<PassDataDemo> {
  final myController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          TextField(
            controller: myController,
            decoration: InputDecoration(labelText: 'Enter Fruit Name'),
          ),
          // Step 1 <-- SEE HERE
          ElevatedButton(
            onPressed: () {
              // Step 3 <-- SEE HERE
              Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(title: myController.text),),);
            },
            child: const Text(
              'Pass Data To Next Screen',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }
}
class DetailScreen extends StatefulWidget {
  // In the constructor, require a Todo.
  const DetailScreen({Key? key, required this.title}) : super(key: key);
  // Step 2 <-- SEE HERE
  final String title;
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}
class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            // Step 4 <-- SEE HERE
            Text(
              '${widget.title}',
              style: TextStyle(fontSize: 54),
            ),
          ],
        ),
      ),
    );
  }
}