import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/widgets/app_layout.dart';

void main() {
  testWidgets('mobile footer appears after the screen reaches its end', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 800));
    await tester.pumpWidget(
      MaterialApp(
        home: AppLayout(
          currentRoute: '/user/home',
          title: 'Inicio',
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(
                30,
                (index) => SizedBox(
                  height: 100,
                  child: Text('Contenido $index'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final footerTitle = find.text('INFORMACIÓN');
    expect(footerTitle, findsNothing);

    await tester.drag(
      find.byType(SingleChildScrollView).first,
      const Offset(0, -5000),
    );
    await tester.pumpAndSettle();

    expect(footerTitle, findsOneWidget);
    expect(tester.getTopLeft(footerTitle).dy, lessThan(800));
    expect(tester.takeException(), isNull);
    await tester.binding.setSurfaceSize(null);
  });
}
