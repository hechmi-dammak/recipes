import 'package:flutter/cupertino.dart';
import 'package:mekla/widgets/common/conditional_widget.dart';

class ConditionalImage extends StatelessWidget {
  const ConditionalImage({Key? key, this.image}) : super(key: key);
  final ImageProvider? image;

  @override
  Widget build(BuildContext context) {
    return ConditionalWidget(
        condition: image != null,
        child: (context) => Image(
              image: image!,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ));
  }
}
