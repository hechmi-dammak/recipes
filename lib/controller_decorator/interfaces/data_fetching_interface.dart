import 'package:flutter/material.dart';

abstract class DataFetchingInterface {
  Future<void> fetchData({callChild = true});

  @protected
  @mustCallSuper
  Future<void> loadData({callChild = true});
}
