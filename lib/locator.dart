import 'package:get_it/get_it.dart';
import 'package:QuizzedGame/services/authentification.dart';
import 'package:QuizzedGame/services/database.dart';

final locator = GetIt.instance;

void setupServices() {
  locator.registerLazySingleton<AuthentificationService>(
      () => AuthentificationService());
  locator.registerLazySingleton<DataBaseService>(() => DataBaseService());
}
