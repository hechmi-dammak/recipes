import 'package:recipes/decorator/base_controller/mixins/data_fetching_base_mixin.dart';
import 'package:recipes/decorator/base_controller/mixins/loading_base_mixin.dart';
import 'package:recipes/decorator/base_controller/mixins/selection_base_mixin.dart';
import 'package:recipes/decorator/controller.dart';

class BaseController extends Controller
    with SelectionBaseMixin, LoadingBaseMixin, DataFetchingBassMixin {}
