import 'package:flutter/material.dart';
import 'package:flutter_crypto_wallet/core/router/shell_router/shell_router_model.dart';
import 'package:go_router/go_router.dart';

class ShellRouter extends StatelessWidget {
  const ShellRouter({
    required this.navigationShell,
    required this.routes,
    super.key,
  });

  final StatefulNavigationShell navigationShell;
  final List<ShellRouterModel> routes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          elevation: 0,
          currentIndex: navigationShell.currentIndex,
          onTap: (index) => _onTap(index),
          items: List.generate(
            routes.length,
            (index) => BottomNavigationBarItem(
              icon: Icon(routes[index].routerIcon),
              label: routes[index].routerTitle,
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
