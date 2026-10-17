import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final logos = [
      const _FooterLogo(
        assetPath: 'assets/images/logo-ingenieria-sistemas.png',
        label: 'Ingeniería de Sistemas',
      ),
      const _FooterLogo(
        assetPath: 'assets/images/sello-acreditacion-sistemas.png',
        label: 'Acreditación de alta calidad',
      ),
      const _FooterLogo(
        assetPath: 'assets/images/ciencias-verdes-igsclac.png',
        label: 'Ciencias Verdes',
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.topbarBorder)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final logoRow = constraints.maxWidth >= 480
              ? Row(children: [for (final logo in logos) Expanded(child: logo)])
              : Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    for (final logo in logos) SizedBox(width: 110, child: logo),
                  ],
                );

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              logoRow,
              const SizedBox(height: 8),
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

class _FooterLogo extends StatelessWidget {
  final String assetPath;
  final String label;

  const _FooterLogo({required this.assetPath, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 38,
          child: Image.asset(
            assetPath,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.account_balance_outlined,
              color: AppColors.textMuted,
              size: 28,
            ),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 9),
        ),
      ],
    );
  }
}
