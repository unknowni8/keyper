import 'package:keyper/app/app.dart';
import 'package:keyper/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
