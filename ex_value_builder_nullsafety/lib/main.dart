import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

import 'ex_value_builder/ex_value_builder.dart';

class Item {
  Item({this.id, this.value});
  final int? id;
  final String? value;
}

int i = 0;

int _getNum() {
  return i++;
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExValueBuilder',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'ExValueBuilder'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ValueNotifier<List<int>> _selectIds = ValueNotifier<List<int>>(<int>[]);

  final List<Item> _items = nouns.take(50).map((String v) => Item(id: _getNum(), value: v)).toList();

  @override
  void dispose() {
    _selectIds.dispose();
    super.dispose();
  }

  void _select(int? id) {
    final List<int> temp = List<int>.from(_selectIds.value);
    if (temp.contains(id)) {
      temp.remove(id);
    } else {
      temp.add(id!);
    }

    _selectIds.value = temp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title!)),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Wrap(
          spacing: 4,
          runSpacing: 4,
          children: _items.map((Item item) => _buildItem(item)).toList(),
        ),
      ),
    );
  }

  Widget _buildItem(Item item) {
    return InkWell(
      onTap: () => _select(item.id),
      child: ExValueBuilder<List<int>>(
        valueListenable: _selectIds,
        shouldRebuild: (List<int> pre, List<int> nex) {
          final bool p = pre.contains(item.id);
          final bool n = nex.contains(item.id);

          return (!p && n) || (p && !n);
        },
        builder: (_, List<int>? ids, Widget? child) {
          print('item rebuild ${item.id} ${item.value}');
          final bool contains = ids!.contains(item.id);
          return AnimatedContainer(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: contains ? Colors.blue : Colors.transparent,
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(4),
            ),
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
            child: Text(item.value!, style: TextStyle(fontSize: 16, color: contains ? Colors.white : Colors.blue)),
          );
        },
      ),
    );
  }
}
