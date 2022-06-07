import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hangout/shared/constant.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController? _textEditingController = TextEditingController();

  Widget buildSearch() {
    return Container(
      decoration: BoxDecoration(
        color: MyConstant.light,
        borderRadius: BorderRadius.circular(12.0)
      ),
      child: TextField(
        controller: _textEditingController,
        decoration: InputDecoration(
            border: InputBorder.none,
            errorBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.all(15.0),
            hintText: 'ค้นหา',
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.primary,
        title: buildSearch(), systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      backgroundColor: MyConstant.primary,
      body: Center(
        child: Text('Search'),
      ),
    );
  }
}
