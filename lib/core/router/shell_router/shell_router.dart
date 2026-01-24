import 'package:flutter/material.dart';
import 'package:flutter_crypto_wallet/core/router/shell_router/shell_router_model.dart';
import 'package:go_router/go_router.dart';

class ShellRouter extends StatelessWidget {
  const ShellRouter({required this.child, required this.routes, super.key});

  final Widget child;
  final List<ShellRouterModel> routes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex(context),
        onTap: (value) => _onTap(context, value),
        items: List.generate(
          routes.length,
          (index) => BottomNavigationBarItem(
            icon: Icon(routes[index].routerIcon),
            label: routes[index].routerTitle,
          ),
        ),
      ),
    );
  }

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    return routes.indexWhere((route) => route.routerPath == location);
  }

  void _onTap(BuildContext context, int index) {
    context.go(routes.elementAt(index).routerPath);
  }
}
