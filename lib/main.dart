import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class Id{
  final List<dynamic> panes;

  Id({this.panes});

  factory Id.fromJson(Map<String,dynamic> json){
    return Id(
      panes: json["panes"],
    );
  }
}

Future<Id> fetchId() async{
  final response = await http.get("http://09f0a17618d5.ngrok.io/api/panes");
  if(response.statusCode == 200){
    return Id.fromJson(json.decode(response.body));
  }else{
    throw Exception("No se encontraron las id's");
  }

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Lista de panes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Future<Id> futureId;

  @override
  void initState() {
    super.initState();
    futureId = fetchId();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }


  List<Widget> display_id(Id id){
    List<Widget> list = [];
    for (var pan in id.panes)
      list.add(
        Card(child: Container(child: Row(
          children: [
            Expanded(
                child: Container(
              child:Text(pan["id"]),
              width: 200,
            ),
            flex: 1,
            ),
            Expanded(
                child: Text(pan["nombre"]),
                    flex: 3,
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
            padding: EdgeInsets.all(16),
        ),
        )

      );
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child:
          FutureBuilder<Id>(
          future: futureId,
          builder: (context, snapshot){
            if(snapshot.hasData){
              var panes = display_id(snapshot.data);
              return ListView(children: panes,);
            }else if(snapshot.hasError){
              return Text("Error");
            }
            return CircularProgressIndicator();
          }
      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
