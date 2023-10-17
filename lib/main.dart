import 'package:demo1/edit_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('my_data_box');
  await Hive.openBox("shopping_box");
  runApp(const MyApp());
}


String? result;
String? output;


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();

  }

  Future<void> fetchDataLocally() async {
    var box = await Hive.openBox('my_data_box');
    String? storedData = box.get('data');

    if (storedData != null) {
      setState(() {
        output = storedData;
      });
    }
  }
  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('https://reqres.in/api/users?page=4'));

      if (response.statusCode == 200) {
        setState(() {
          result = response.body; // Extract the response body as a String.
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  Future<void> storeDataLocally() async {
    var box = await Hive.openBox('my_data_box');
    if (result != null) {
      await box.put('data', result);
      print("data stored");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Request and Local Storage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Data: ${result ?? "Data not loaded"}'),
            ElevatedButton(
              onPressed: fetchData,
              child: const Text('Fetch Data'),
            ),
            ElevatedButton(
              onPressed: storeDataLocally,
              child: const Text('Store Locally'),
            ),


            ElevatedButton(
              onPressed: fetchDataLocally,
              child: const Text('Fetch Locally'),
            ),
            Text('Data: ${output ?? "Data not loaded"}'),
            ElevatedButton(
              onPressed:(){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Edit_Page()),
                );
              },
              child: const Text('Go to Next Page'),
            ),
          ],
        ),
      ),
    );
  }
}
