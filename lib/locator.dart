import 'package:friend_circle/repository/user_repository.dart';
import 'package:friend_circle/services/firebase_auth_service.dart';
import 'package:friend_circle/services/firebase_storage_service.dart';
import 'package:friend_circle/services/firestore_db_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.I;

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => FirestoreDBService());
  locator.registerLazySingleton(() => FirebaseStorageService());
}
