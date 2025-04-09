import 'package:facturation_intuitive/main.dart';
import 'package:facturation_intuitive/utils/themes/colors.dart';
import 'package:facturation_intuitive/utils/themes/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DefaultAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool hasLeading;
  final IconData? iconLeading;
  final String? textLeading;
  final String? textAction;
  final VoidCallback? onPressedLeading;
  final bool hasActions;
  final IconData? iconActions;
  final VoidCallback? onPressedAction;
  final String? iconAssets;

  const DefaultAppbar({
    super.key,
    required this.title,
    this.hasLeading = false,
    this.iconLeading,
    this.textLeading,
    this.hasActions = false,
    this.iconActions,
    this.onPressedLeading,
    this.onPressedAction,
    this.iconAssets,
    this.textAction,
  })  : assert(
          !(hasLeading && onPressedLeading == null),
          'onPressedLeading cannot be null when hasLeading is true',
        ),
        assert(
          !(hasLeading &&
              (iconLeading == null &&
                  iconAssets == null &&
                  textLeading == null)),
          'Either iconLeading, iconAssets, or textLeading must be provided when hasLeading is true',
        ),
        assert(
          !(hasActions && onPressedAction == null),
          'onPressedAction cannot be null when hasActions is true',
        );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final ThemeController themeController = Get.find<ThemeController>();
      final isLightTheme = themeController.themeMode.value == ThemeMode.light;
      return AppBar(
        toolbarHeight: kToolbarHeight,
        backgroundColor: isLightTheme ? ColorsTheme.blueColor : ColorsTheme.darkGreyColor,
        leadingWidth: textLeading != null ? mq.width * 0.22 : 50,
        leading: hasLeading
            ? textLeading == null
                ? iconAssets != null
                    ? MaterialButton(
                        onPressed: onPressedAction,
                        child: Image.asset(
                          iconAssets!,
                          height: mq.height * 0.03,
                          color: Colors.white,
                        ),
                      )
                    : IconButton(
                        padding: EdgeInsets.only(left: mq.width * 0.04),
                        onPressed: onPressedLeading,
                        iconSize: mq.aspectRatio * 60,
                        icon: Icon(iconLeading, color: Colors.white),
                      )
                : MaterialButton(
                    onPressed: onPressedLeading,
                    child: Text(
                      textLeading ?? '',
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
            : const SizedBox(),
        title: Text(
          title,
          overflow: TextOverflow.visible,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: mq.aspectRatio * 40,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        titleSpacing: hasActions ? mq.width * 0.07 : mq.width* 0.15,
        actions: hasActions
            ? [
          iconAssets != null
              ? MaterialButton(
            onPressed: onPressedAction,
            child: Image.asset(
              iconAssets!,
              height: mq.height * 0.03,
              color: Colors.white,
            ),
          )
              : IconButton(
            padding: EdgeInsets.only(right: mq.width * 0.04),
            onPressed: onPressedAction,
            iconSize: mq.aspectRatio * 60,
            icon:  Icon(
              iconActions,
              color: Colors.white,
            ),
          ),
          if (textAction != null)
            SizedBox(
              width: mq.width * 0.24,
              child: MaterialButton(
                onPressed: onPressedAction,
                padding: EdgeInsets.zero,
                child: Text(
                  textAction ?? '',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
        ] : [],
      );
    },
    );
  }
}
