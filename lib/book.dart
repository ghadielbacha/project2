import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String _baseURL = 'ghadi.atwebpages.com';


class Book {
  final int _bid;
  final String _title;
  final String _author;
  final int _quantity;
  final double _price;
  final String _category;

  Book(this._bid, this._title, this._author, this._quantity, this._price, this._category);

  @override
  String toString() {
    return 'BID: $_bid Title: $_title\nAuthor: $_author\nQuantity: $_quantity \nPrice: \$$_price\nCategory: $_category';
  }
}

List<Book> _books = [];


void updateBooks(Function(bool success) update) async {
  try {
    final url = Uri.http(_baseURL, 'getBooks.php');
    final response = await http.get(url)
        .timeout(const Duration(seconds: 5));
    _books.clear();
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      for (var row in jsonResponse) {
        Book b = Book(
            int.parse(row['bid']),
            row['title'],
            row['author'],
            int.parse(row['quantity']),
            double.parse(row['price']),
            row['category']);
        _books.add(b);
      }
      update(true);
    }
  }
  catch(e) {
    update(false);
  }
}


void searchBook(Function(String text) update, int bid) async {
  try {
    final url = Uri.http(_baseURL, 'getBooks.php', {'bid':'$bid'});
    final response = await http.get(url)
        .timeout(const Duration(seconds: 5));
    _books.clear();
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      var row = jsonResponse[0];
      Book b = Book(
          int.parse(row['bid']),
          row['title'],
          row['author'],
          int.parse(row['quantity']),
          double.parse(row['price']),
          row['category']);
      _books.add(b);
      update(b.toString());
    }
  }
  catch(e) {
    update("can't load data");
  }
}


class ShowBooks extends StatelessWidget {
  const ShowBooks({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ListView.builder(
        itemCount: _books.length,
        itemBuilder: (context, index) => Column(children: [
          const SizedBox(height: 10),
          Container(
              color: index % 2 == 0 ? Colors.lightBlueAccent: Colors.yellowAccent,
              padding: const EdgeInsets.all(5),
              width: width * 0.9, child: Row(children: [
            SizedBox(width: width * 0.15),
            Flexible(child: Text(_books[index].toString(), style: TextStyle(fontSize: width * 0.045)))
          ]))
        ]));
  }
}

