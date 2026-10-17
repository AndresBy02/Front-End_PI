import 'package:flutter/material.dart';

import 'core/constants/app_colors.dart';
import 'widgets/app_layout.dart';

void main() {
  runApp(const FooterPreviewApp());
}

class FooterPreviewApp extends StatelessWidget {
  const FooterPreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vista previa del pie · LabAcces',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryGreen),
        useMaterial3: true,
      ),
      home: const AppLayout(
        currentRoute: '/preview',
        title: 'Vista previa del pie',
        subtitle: 'LabAcces · Verificación visual',
        child: _PreviewContent(),
      ),
    );
  }
}

class _PreviewContent extends StatelessWidget {
  const _PreviewContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Así se ve el pie en las pantallas internas',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Esta vista es solo una demostración del layout compartido. '
                    'No inicia sesión ni se conecta al backend.',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
