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
          final isWide = constraints.maxWidth >= 700;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isWide)
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 2, child: _ContactDetails()),
                    SizedBox(width: 24),
                    Expanded(flex: 3, child: _BrandMarks()),
                  ],
                )
              else
                const Column(
                  children: [
                    _ContactDetails(),
                    SizedBox(height: 16),
                    _BrandMarks(),
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
        _ContactLine(
          icon: Icons.email_outlined,
          text: 'igsclac@gmail.com',
        ),
        SizedBox(height: 6),
        _ContactLine(
          icon: Icons.location_on_outlined,
          text:
              'Carrera 27A #48-144, Kilómetro 1 Salida Sur, Tuluá, Valle del Cauca',
        ),
        SizedBox(height: 6),
        _ContactLine(
          icon: Icons.phone_outlined,
          text: '+57 (602) 231 7222',
        ),
      ],
    );
  }
}

class _ContactLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ContactLine({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primaryGreen, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: SelectableText(
            text,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class _BrandMarks extends StatelessWidget {
  const _BrandMarks();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const _Isotipo(
              assetPath: 'assets/images/uceva-isotipo.png',
              label: 'UCEVA',
            ),
            const SizedBox(width: 10),
            Flexible(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 150),
                child: AspectRatio(
                  aspectRatio: 1440 / 399,
                  child: Image.asset(
                    'assets/images/banner-ingenieria-sistemas.webp',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Text(
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
              ),
            ),
            const SizedBox(width: 10),
            const _Isotipo(
              assetPath: 'assets/images/ciencias-verdes-isotipo.png',
              label: 'Ave de Ciencias Verdes',
            ),
          ],
        ),
        const SizedBox(height: 8),
        Semantics(
          label: 'Logo de Ciencias Verdes IGSCLAC',
          image: true,
          child: SizedBox(
            width: 88,
            height: 88,
            child: Image.asset(
              'assets/images/ciencias-verdes-igsclac.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.eco_outlined,
                color: AppColors.primaryGreen,
                size: 48,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Isotipo extends StatelessWidget {
  final String assetPath;
  final String label;

  const _Isotipo({required this.assetPath, required this.label});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      image: true,
      child: SizedBox(
        width: 52,
        height: 52,
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.image_not_supported_outlined,
            color: AppColors.textMuted,
            size: 32,
          ),
        ),
      ),
    );
  }
}
