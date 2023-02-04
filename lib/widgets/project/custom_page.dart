import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/decorator/controller.dart';
import 'package:recipes/widgets/common/loading_widget.dart';

abstract class CustomPage<T extends Controller> extends StatelessWidget {
  const CustomPage({Key? key}) : super(key: key);

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
          return Scaffold(
            bottomNavigationBar: bottomNavigationBarBuilder(controller, context),
            appBar: appBarBuilder(controller, context),
            body: SafeArea(
                child: LoadingWidget(
                    loading: controller.getLoading(),
                    child: RefreshIndicator(
                        onRefresh: controller.fetchData,
                        child: bodyBuilder(controller, context)))),
          );
        });
  }
}
