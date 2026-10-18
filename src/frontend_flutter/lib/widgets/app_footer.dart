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
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _HeaderMarks(),
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

class _HeaderMarks extends StatelessWidget {
  const _HeaderMarks();

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _HeaderMark(
            assetPath: 'assets/images/uceva-isotipo.png',
            label: 'UCEVA',
          ),
          SizedBox(width: 16),
          _HeaderMark(
            assetPath: 'assets/images/ciencias-verdes-isotipo.png',
            label: 'Ciencias Verdes',
          ),
        ],
      ),
    );
  }
}

class _HeaderMark extends StatelessWidget {
  final String assetPath;
  final String label;

  const _HeaderMark({required this.assetPath, required this.label});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      image: true,
      child: SizedBox(
        width: 64,
        height: 64,
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
