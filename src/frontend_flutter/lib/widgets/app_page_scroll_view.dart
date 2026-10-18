import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'custom_footer.dart';

class AppBanner extends StatelessWidget {
  const AppBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompactWebBanner = kIsWeb && screenWidth >= 960;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bannerWidth = isCompactWebBanner && constraints.maxWidth > 560
            ? 560.0
            : constraints.maxWidth;

        return Container(
          width: double.infinity,
          color: const Color(0xFF050506),
          alignment: Alignment.centerLeft,
          child: Image.asset(
            'assets/images/banner_sistemas.jpeg',
            width: bannerWidth,
            fit: BoxFit.fitWidth,
            semanticLabel: 'Banner de la Facultad de Ingeniería de Sistemas',
          ),
        );
      },
    );
  }
}

class AppPageScrollView extends StatelessWidget {
  final Widget child;

  const AppPageScrollView({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.sizeOf(context).width >= 960) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: child,
      );
    }

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(child: AppBanner()),
        SliverToBoxAdapter(child: child),
        const SliverToBoxAdapter(child: CustomFooter()),
      ],
    );
  }
}
