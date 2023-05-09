import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/decorator/decorators.dart';
import 'package:recipes/widgets/common/conditional_parent_widget.dart';
import 'package:recipes/widgets/common/loading_widget.dart';

abstract class CustomPage<T extends Controller> extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GetBuilder<T>(
        initState: Get.find<T>().initState,
        builder: (controller) {
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
              bottomNavigationBar:
                  bottomNavigationBarBuilder(controller, context),
              appBar: appBarBuilder(controller, context),
              body: SafeArea(
                  child: LoadingWidget(
                      loading: controller.loading,
                      child: (context) => RefreshIndicator(
                          onRefresh: controller.fetchData,
                          child: bodyBuilder(controller, context)))),
            ),
          );
        });
  }
}
