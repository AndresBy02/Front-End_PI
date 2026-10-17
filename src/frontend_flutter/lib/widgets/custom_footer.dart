import 'package:flutter/material.dart';

class CustomFooter extends StatelessWidget {
  const CustomFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      width: double.infinity,
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 30.0,
            runSpacing: 20.0,
            children: [
              _buildLogo('assets/images/sistemas.png'),
              _buildLogo('assets/images/acreditacion.png'),
              _buildLogo('assets/images/ciencias.png'),
            ],
          ),
          const SizedBox(height: 15),
          const Text(
            '© 2026 UCEVA · Facultad de Ingeniería de Sistemas',
            style: TextStyle(fontSize: 12, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(String path) {
    return Image.asset(
      path,
      height: 60,
      errorBuilder: (context, error, stackTrace) => const Icon(
        Icons.image_not_supported,
        size: 60,
        color: Colors.grey,
      ),
    );
  }
}