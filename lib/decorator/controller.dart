import 'package:get/get.dart';
import 'package:mekla/decorator/interfaces/data_fetching_interface.dart';
import 'package:mekla/decorator/interfaces/loading_interface.dart';
import 'package:mekla/decorator/interfaces/selection_interface.dart';

abstract class Controller extends GetxController
    implements LoadingInterface, DataFetchingInterface, SelectionInterface {}
