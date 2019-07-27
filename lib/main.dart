import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Drag and Drop Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ItemModel> items;
  List<ItemModel> items2;
  int score;
  bool gameOver;

  @override
  void initState() {
    super.initState();
    initGame();
  }

  initGame() {
    gameOver = false;
    score = 0;
    items = [
      ItemModel(icon: FontAwesomeIcons.google, name: "Google", value: "google"),
      ItemModel(icon: FontAwesomeIcons.facebook, name: "Facebook", value: "facebook"),
      ItemModel(icon: FontAwesomeIcons.twitter, name: "Twitter", value: "twitter"),
      ItemModel(icon: FontAwesomeIcons.linkedin, name: "Linked In", value: "linkedin"),
      ItemModel(icon: FontAwesomeIcons.instagram, name: "Instagram", value: "instagram"),
    ];
    items2 = List<ItemModel>.from(items);
    items.shuffle();
    items2.shuffle();
  }

  @override
  Widget build(BuildContext context){
    if(items.length == 0)
      gameOver = true;
    return Scaffold(
      appBar: AppBar(
        title: Text('Drag&Drop Game'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text.rich(TextSpan(
              children: [
                TextSpan(text: "Score: "),
                TextSpan(text: "$score", style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0
                ))
              ]
            )),
            if(!gameOver)
            Row(
              children: <Widget>[
                Column(
                  children: items.map((item){
                    return Container(
                      margin: const EdgeInsets.all(8.0),
                      child: Draggable<ItemModel>(
                        data: item,
                        childWhenDragging: Icon(item.icon, color: Colors.grey, size: 50,),
                        feedback: Icon(item.icon,color: Colors.red, size: 50,),
                        child: Icon(item.icon, color: Colors.red, size: 50,)));
                  }).toList()
                ),
                Spacer(),
                Column(
                  children: items2.map((item){
                    return DragTarget<ItemModel>(
                      onAccept: (receivedItem) {
                        if(item.value == receivedItem.value) {
                          setState(() {
                            items.remove(receivedItem);
                            items2.remove(item);
                            score+=10;
                            item.accepting = false;
                          });
                        }else{
                          setState(() {
                            score-=5;
                            item.accepting = false;
                          });
                        }
                      },
                      onLeave: (receivedItem) {
                        setState(() {
                          item.accepting = false;
                        });
                      },
                      onWillAccept: (receivedItem) {
                        setState(() {
                          item.accepting = true;
                        });
                        return true;
                      },
                      builder: (context, acceptedItems, rejectedItems) => Container(
                        color: item.accepting ? Colors.red.shade300 : Colors.red,
                        height: 50,
                        width: 100,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(8.0),
                        child: Text(item.name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),)),
                    );
                  }).toList()
                ),
              ],
            ),
            if(gameOver)
            Text("Game Over", style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 24.0
            ),),
            if(gameOver)
            RaisedButton(
              textColor: Colors.white,
              color: Colors.pink,
              child: Text("New Game"),
              onPressed: (){
                initGame();
                setState(() {});
              },
            )
          ],
        ),
      ),
    );
  }
}

class ItemModel {
  final String name;
  final String value;
  final IconData icon;
  bool accepting;

  ItemModel({this.name, this.value, this.icon, this.accepting=false});
}