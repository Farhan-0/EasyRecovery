import 'package:flutter/material.dart';

class MenuItem {
  final String menuText;
  final IconData menuIcon;

  const MenuItem({
    required this.menuText,
    required this.menuIcon,
  });
}

class MenuItems {
  static const List<MenuItem> menuItemList = [
    itemLogout,
    itemAddAgent,
  ];

  static const itemLogout = MenuItem(
    menuText: 'Logout',
    menuIcon: Icons.exit_to_app_rounded,
  );
  static const itemAddAgent = MenuItem(
    menuText: 'Add Agent',
    menuIcon: Icons.exit_to_app_rounded,
  );
}
