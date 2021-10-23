import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipes/modules/recipe_edit_page/controller/recipe_edit_controller.dart';

class ImageEditField extends StatefulWidget {
  const ImageEditField({Key? key}) : super(key: key);

  @override
  _ImageEditFieldState createState() => _ImageEditFieldState();
}

class _ImageEditFieldState extends State<ImageEditField> {
  final RecipeEditController recipeEditController = RecipeEditController.find;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipeEditController>(builder: (_) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).colorScheme.primary, width: 4),
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey,
          image: recipeEditController.recipe.value.picture == null ||
                  recipeEditController.recipe.value.picture!.image == null
              ? null
              : DecorationImage(
                  image: MemoryImage(
                      recipeEditController.recipe.value.picture!.image!),
                  fit: BoxFit.cover,
                ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.25),
              spreadRadius: 2,
              blurRadius: 2,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        margin: const EdgeInsets.only(bottom: 10),
        width: double.infinity,
        height: (MediaQuery.of(context).size.width - 40) * 0.5625,
        child: Stack(
          children: [
            recipeEditController.recipe.value.picture == null
                ? Container()
                : Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        RoundedButton(
                          onPressed: () {
                            setState(() {
                              recipeEditController.recipe.value.picture = null;
                            });
                          },
                          child: Icon(
                            Icons.close_rounded,
                            color: Theme.of(context).colorScheme.onSecondary,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RoundedButton(
                    onPressed: () =>
                        recipeEditController.getImage(ImageSource.camera),
                    child: Icon(
                      Icons.camera_alt,
                      color: Theme.of(context).colorScheme.onSecondary,
                      size: 30,
                    ),
                  ),
                  RoundedButton(
                    onPressed: () =>
                        recipeEditController.getImage(ImageSource.gallery),
                    child: Icon(
                      Icons.image,
                      color: Theme.of(context).colorScheme.onSecondary,
                      size: 30,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}

class RoundedButton extends StatelessWidget {
  const RoundedButton({Key? key, required this.child, required this.onPressed})
      : super(key: key);
  final Function() onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: Container(
              child: child,
              padding: const EdgeInsets.all(5),
            ),
          ),
        ),
      ),
    );
  }
}
