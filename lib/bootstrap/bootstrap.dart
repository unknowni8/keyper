import 'dart:async';
import 'dart:developer';

import 'package:app_logger/app_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:keyper/bootstrap/app_bloc_observer.dart';
import 'package:path_provider/path_provider.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      Bloc.observer = const AppBlocObserver();
      await AppLoggerConfig.instance.initialize();
      
      // Initialize hydrated storage in a web-safe way.
      if (kIsWeb) {
        HydratedBloc.storage = await HydratedStorage.build(
          storageDirectory: HydratedStorageDirectory.web,
        );
      } else {
        final storageDir = await getApplicationSupportDirectory();
        HydratedBloc.storage = await HydratedStorage.build(
          storageDirectory: HydratedStorageDirectory(storageDir.path),
        );
      }
      // if (kDebugMode) {
      //   await HydratedBloc.storage.clear();
      // }

      runApp(await builder());
    },
    (error, stackTrace) {
      log(error.toString(), stackTrace: stackTrace);
    },
  );
}
