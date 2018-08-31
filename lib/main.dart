import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
//  Widget build(BuildContext context) {
//    final wordPair = new WordPair.random();
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Startup Name Generator',
      theme: new ThemeData(
        primaryColor: Colors.black,
      ),
      home: new RandomWords(),
    );
//    }
  }
}

class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];

  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _fontSmall = const TextStyle(fontSize: 12.0);
  final _saved = new Set<WordPair>();
  List data;

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = ListTile
              .divideTiles(
                context: context,
                tiles: tiles,
              )
              .toList();
          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Saved Suggestions'),
            ),
            body: new ListView(children: divided),
          );
        },
      ),
    );
  }

  Future<String> getData() async {
    var request = await http
        .get("http://api.douban.com/v2/movie/top250?start=0&count=10");
    setState(() {
      var res = json.decode(request.body);
      data = res['subjects'];
      print(data[0]);
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
//    final wordPair = new WordPair.random();
//    return new Text(wordPair.asPascalCase);
    Column buildButtonColumn(IconData icon, String label) {
      Color color = Theme.of(context).primaryColor;
      return new Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new Icon(icon, color: color),
          new Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: new Text(
              label,
              style: new TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ),
        ],
      );
    }

    Widget buttonSection = new Container(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildButtonColumn(Icons.call, 'CALL'),
          buildButtonColumn(Icons.near_me, 'ROUTE'),
          buildButtonColumn(Icons.share, 'SHARE'),
        ],
      ),
    );

    Widget buildListTile(BuildContext context,String item){
      return new ListTile(
        isThreeLine: true,//子item的是否为三行
        dense: false,
        leading: new CircleAvatar(child: new Text(item),),//左侧首字母图标显示，不显示则传null
        title: new Text('子item的标题'),//子item的标题
        subtitle: new Text('子item的内容'),//子item的内容
        trailing: new Icon(Icons.arrow_right,color: Colors.green,),//显示右侧的箭头，不显示则传null
      );
    }

    Widget textSection = new Container(
      padding: const EdgeInsets.all(32.0),
      child: new Text(
        'Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese Alps.',
        softWrap: true,
      ),
    );

    List<String> items=<String>['A','B','C','D','E','F','G','H','J'];
    Iterable<Widget> listTitles=items.map((String item){//将items的内容设置给Adapter
      return buildListTile(context,item);
    });
    listTitles=ListTile.divideTiles(context: context,tiles: listTitles);//给Listview设置分隔线

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Startup title Generator'),
          actions: <Widget>[
            new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved),
          ],
        ),
        body: new Column(
          children: <Widget>[
            _buildImg('bg1.jpg'),
            _buildTitleTxt(),
            buttonSection,
//            textSection,

            new Flexible (child: _buildSuggestions()),
//          _buildImg('bg2.jpg'),
//          _buildSuggestions()
          ],

        ));
    //
  }

  Widget _buildImg(String _path) {
    return new Image.asset('images/' + _path, height: 240.0, fit: BoxFit.cover);
  }

  Widget _buildTitleTxt() {
    return new Container(
        padding: const EdgeInsets.all(32.0),
        child: new Row(children: <Widget>[
          new Expanded(
              child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center, //align
            children: [
              new Container(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: new Text(
                  'Oeschinen Lake Campground',
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              new Text(
                'Kandersteg, Switzerland',
                style: new TextStyle(
                  color: Colors.grey[500],
                ),
              ),
            ],
          )),
          new Icon(
            Icons.star,
            color: Colors.red[500],
          ),
          new Text('41'),
          new GestureDetector(
            onTap: () {
              print('BUtton was tapped111');
              getData();
            },
            child: new Container(
              //Container：矩形控件，可与BoxDecoration配合来装饰 background, a border, or a shadow，
              // 可用margins, padding, and constraints来设置其尺寸。
              height: 30.0,
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(5.0), //背景的圆角
                color: Colors.lightGreen[500],
              ), //背景色
              child: new Center(
                child: new Text('Engage'),
              ), //显示 "Engage"
            ),
          ),
        ]));
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
//        shrinkWrap: true,
//        itemCount: 100,
        padding: const EdgeInsets.all(8.0),
        // The itemBuilder callback is called once per suggested word pairing,
        // and places each suggestion into a ListTile row.
        // For even rows, the function adds a ListTile row for the word pairing.
        // For odd rows, the function adds a Divider widget to visually
        // separate the entries. Note that the divider may be difficult
        // to see on smaller devices.
        itemBuilder: (context, i) {
          // Add a one-pixel-high divider widget before each row in theListView.
          if (i.isOdd) return new Divider();

          // The syntax "i ~/ 2" divides i by 2 and returns an integer result.
          // For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
          // This calculates the actual number of word pairings in the ListView,
          // minus the divider widgets.
          final index = i ~/ 2;
          // If you've reached the end of the available word pairings...
          if (index >= _suggestions.length) {
            // ...then generate 10 more and add them to the suggestions list.
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index], index);
        });
  }

  Widget _buildRow(WordPair pair, _index) {
    final alreadySaved = _saved.contains(pair);
    return new ListTile(
      leading: new Text((_index + 1).toString()),
      title: new Text(
        data[_index]['title'],
        style: _biggerFont,
      ),
      subtitle: new Text(
        data[_index]['genres'][0],
        style: _fontSmall,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }
}
