import 'package:flutter/material.dart';

abstract class DataFetchingInterface {
  Future<void> fetchData({bool callChild = true});

  @protected
  @mustCallSuper
  Future<void> loadData({bool callChild = true});
}
