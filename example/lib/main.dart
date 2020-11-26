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
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      child: Center(
          child: WidgetPageGesture(
              toLeftEnd: () => setState(() => index--),
              toRightEnd: () => setState(() => index++),
              toBottomEnd: () => setState(() => index += 10),
              toTopEnd: () => setState(() => index -= 10),
              width: width,
              height: height,
              child: Container(
                width: width,
                height: height,
                color: Colors.greenAccent,
                child: Center(
                  child: Text(
                    "$index",
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ))),
    );
  }
}
