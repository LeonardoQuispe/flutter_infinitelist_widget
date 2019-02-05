import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';


void main() {
  runApp(new MaterialApp(
   home: RandomWords(),
  ));
}


class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => new _RandomWordsState();
 }


class _RandomWordsState extends State<RandomWords> {
  
  final _suggestions = <WordPair>[];
  final _saved = new Set<WordPair>();


  Widget _buildSuggestions() {
    return new ListView.builder(
      itemBuilder: (context, i) {
        if (i.isOdd) {
          return new Divider();
        }

        final index = i ~/ 2;

        if( index >= _suggestions.length ) {
          _suggestions.addAll(generateWordPairs().take(10));
        }

        return _buildRow(_suggestions[index]);
      },
    );
  }


  Widget _buildRow(WordPair pair) {
    
    final bool _alreadySave = _saved.contains(pair);

    return ListTile(
      title: new Text(
        pair.asPascalCase
      ),
      trailing: new Icon(
        _alreadySave ? Icons.favorite : Icons.favorite_border
        , color: Colors.red,),

      onTap: () {        
        setState(() {
          if (_alreadySave) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });        
      },

    );

  }


  @override
  Widget build(BuildContext context) {
   return new Scaffold(
     appBar: new AppBar(
       title: new Text("Lista Infinita"),
       centerTitle: true,
     ),

    body: _buildSuggestions(),

    floatingActionButton: mostrarSnackBar()
   );
  }



  void mostrarModal(context, divided) {
      
      showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {  
          return new ListView( 
            children: divided,
          );
        }
      );
   
  }


  mostrarSnackBar() {
    return new Builder(builder: (BuildContext contexto) {
        return new FloatingActionButton(

          onPressed: () {



            final tiles = _saved.map(
              (pair){
              return new ListTile(title: new Text(pair.asPascalCase),);
            });

            final divided = ListTile.divideTiles(
              context: contexto,
              tiles: tiles,
            ).toList();

            if (tiles.length > 0) {
              mostrarModal(contexto, divided);
            } else {
              Scaffold.of(contexto).showSnackBar(new SnackBar(
                content: new Text("No hay elementos en Favoritos ;-("),
                duration: new Duration(seconds: 3),
                action: new SnackBarAction(
                  label: "¿Verdad?",
                  onPressed: () {
                    Scaffold.of(contexto).showSnackBar(
                      new SnackBar(
                        content: new Text("Si, ni modo ;-("),
                        duration: new Duration(seconds: 1, milliseconds: 50),
                      )
                    );
                  },
                ),
                ),
              );
              // mostrarSnackBar(context);
            }
          
            




          },
          tooltip: "Ver Favoritos",
          child: new Icon(Icons.remove_red_eye),
        );
    });
  }


}
