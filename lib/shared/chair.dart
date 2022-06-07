import 'package:flutter/material.dart';
import 'package:hangout/shared/constant.dart';

class MyChairs {

  static Widget availbleChair() {
    return Container(
      height: 10.0,
      width: 10.0,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(6.0)
      ),
    );
  }

  static Widget reservedChair() {
    return Container(
      height: 10.0,
      width: 10.0,
      decoration: BoxDecoration(
        color: MyConstant.focus,
        borderRadius: BorderRadius.circular(6.0)
      ),
    );
  }

  static Widget selectedChair() {
    return Container(
      height: 10.0,
      width: 10.0,
      decoration: BoxDecoration(
        color: MyConstant.light,
        borderRadius: BorderRadius.circular(6.0)
      ),
    );
  }
}
