import 'package:flutter/material.dart';

import '../theme/app_gradients.dart';

/// Paints [AppGradients.scaffold] behind tab content; scaffolds stay transparent.
class AppGradientScaffold extends StatelessWidget {
  final Widget child;

  const AppGradientScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(decoration: BoxDecoration(gradient: AppGradients.scaffold)),
        child,
      ],
    );
  }
}
