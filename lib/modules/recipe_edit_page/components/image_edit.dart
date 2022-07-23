import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipes/modules/recipe_edit_page/recipe_edit_controller.dart';

class ImageEditField extends StatelessWidget {
  const ImageEditField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipeEditController>(builder: (recipeEditController) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Get.theme.colorScheme.primary, width: 4),
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey,
          image: recipeEditController.recipe.picture == null ||
                  recipeEditController.recipe.picture!.image == null
              ? null
              : DecorationImage(
                  image:
                      MemoryImage(recipeEditController.recipe.picture!.image!),
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
        height: (MediaQuery.of(context).size.width - 40) * 0.7,
        child: Stack(
          children: [
            recipeEditController.recipe.picture == null
                ? Container()
                : Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        RoundedButton(
                          onPressed: () {
                            recipeEditController.clearRecipeImage();
                          },
                          child: Icon(
                            Icons.close_rounded,
                            color: Get.theme.colorScheme.onSecondary,
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
                      color: Get.theme.colorScheme.onSecondary,
                      size: 30,
                    ),
                  ),
                  RoundedButton(
                    onPressed: () =>
                        recipeEditController.getImage(ImageSource.gallery),
                    child: Icon(
                      Icons.image,
                      color: Get.theme.colorScheme.onSecondary,
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
            color: Get.theme.colorScheme.secondary,
          ),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: Container(
              padding: const EdgeInsets.all(5),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
