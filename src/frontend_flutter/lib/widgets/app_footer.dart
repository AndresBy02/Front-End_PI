import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.topbarBorder)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bannerHeight =
              constraints.maxWidth < 560 ? constraints.maxWidth / 3.6 : 150.0;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: bannerHeight,
                child: Center(
                  child: Image.asset(
                    'assets/images/banner-ingenieria-sistemas.webp',
                    width: double.infinity,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Text(
                      'Ingeniería de Sistemas · Acreditación de Alta Calidad',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textStrong,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(height: 20),
              if (constraints.maxWidth >= 560)
                const Row(
                  children: [
                    Expanded(child: _ScienceBrand()),
                    SizedBox(width: 24),
                    Expanded(flex: 2, child: _ContactDetails()),
                  ],
                )
              else
                const Column(
                  children: [
                    _ScienceBrand(),
                    SizedBox(height: 12),
                    _ContactDetails(),
                  ],
                ),
              const SizedBox(height: 10),
              const Text(
                '© 2026 UCEVA · Facultad de Ingeniería de Sistemas',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted, fontSize: 10),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ScienceBrand extends StatelessWidget {
  const _ScienceBrand();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 112,
      child: Image.asset(
        'assets/images/ciencias-verdes-igsclac.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.eco_outlined,
          color: AppColors.primaryGreen,
          size: 48,
        ),
      ),
    );
  }
}

class _ContactDetails extends StatelessWidget {
  const _ContactDetails();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Información',
          style: TextStyle(
            color: AppColors.textStrong,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.email_outlined, color: AppColors.primaryGreen, size: 18),
            SizedBox(width: 8),
            Flexible(
              child: SelectableText(
                'igsclac@gmail.com',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
