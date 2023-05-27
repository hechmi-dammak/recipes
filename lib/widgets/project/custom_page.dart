import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/decorator/decorators.dart';
import 'package:mekla/widgets/common/conditional_parent_widget.dart';
import 'package:mekla/widgets/common/getx/get_builder_view.dart';
import 'package:mekla/widgets/common/loading_widget.dart';

abstract class CustomPage<T extends Controller> extends StatelessWidget
    with GetBuilderView<T> {
  final bool hasSelection;

  const CustomPage({Key? key, this.hasSelection = false}) : super(key: key);

  Widget bodyBuilder(T controller, BuildContext context);

  Widget? bottomNavigationBarBuilder(T controller, BuildContext context) {
    return null;
  }

  PreferredSizeWidget? appBarBuilder(T controller, BuildContext context) {
    return null;
  }

  @override
  void initState(GetBuilderState<T> state) => controller.initState(state);

  @override
  Widget getBuilder(BuildContext context, controller) {
    return ConditionalParentWidget(
      condition: hasSelection,
      parentBuilder: (context, child) => WillPopScope(
        onWillPop: () async {
          if (controller.selectionIsActive) {
            controller.setSelectAllValue();
            return false;
          }
          return true;
        },
        child: child,
      ),
      child: Scaffold(
        bottomNavigationBar: bottomNavigationBarBuilder(controller, context),
        appBar: appBarBuilder(controller, context),
        body: SafeArea(
            child: LoadingWidget(
                loading: controller.loading,
                child: (context) => RefreshIndicator(
                    onRefresh: controller.fetchData,
                    child: bodyBuilder(controller, context)))),
      ),
    );
  }
}
