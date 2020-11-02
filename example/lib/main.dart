import 'package:flutter/material.dart';
import 'package:flutter_widget_collection/flutter_widget_collection.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TimeChooseController timeChooseController;

  @override
  void initState() {
    super.initState();
    timeChooseController = TimeChooseController();
    timeChooseController.watchChanged.listen((event) {
      print("Changed: $event");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Widget collection"),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 2 / 3,
          height: MediaQuery.of(context).size.width,
          child: WidgetTimeChoose(
              height: MediaQuery.of(context).size.width,
              controller: timeChooseController),
        ),
      ),
    );
  }
}
