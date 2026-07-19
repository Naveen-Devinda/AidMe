import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:aidme/main.dart';
import 'package:aidme/providers/theme_provider.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MyApp(),
      ),
    );
    await tester.pump();
  });
}
