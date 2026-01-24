import 'package:flutter/widgets.dart';

class ShellRouterModel {
  const ShellRouterModel({
    required this.routerIcon,
    required this.routerTitle,
    required this.routerPath,
  });

  final IconData routerIcon;
  final String routerTitle;
  final String routerPath;
}
