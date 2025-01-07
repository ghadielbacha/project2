import 'package:flutter/material.dart';
import 'book.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  final TextEditingController _controllerID = TextEditingController();
  String _text = '';

  @override
  void dispose() {
    _controllerID.dispose();
    super.dispose();
  }


  void update(String text) {
    setState(() {
      _text = text;
    });
  }


  void getBook() {
    try {
      int bid = int.parse(_controllerID.text);
      searchBook(update, bid);
    }
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('wrong arguments')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Book'),
        centerTitle: true,
      ),
      body: Center(child: Column(children: [
        const SizedBox(height: 10),
        SizedBox(width: 200,
            child: TextField(
                controller: _controllerID, keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Enter ID'))),
        const SizedBox(height: 10),
        ElevatedButton(onPressed: getBook,
            child: const Text('Find', style: TextStyle(fontSize: 18))),
        const SizedBox(height: 10),
        Center(child: SizedBox(width: 200, child: Flexible(child: Text(_text,
            style: const TextStyle(fontSize: 18))))),
      ],
      ),
      ),
    );
  }
}

