import 'package:get_it/get_it.dart';
import '../../data/datasources/event_remote_datasource.dart';
import '../../data/repositories/event_repository_impl.dart';
import '../../domain/repositories/event_repository.dart';
import '../../features/events/bloc/event_bloc.dart';
import '../api/api_client.dart';

/// Dependency Injection Container
/// 
/// Central sted til at registrere og resolve dependencies.
/// Bruger get_it som service locator.
/// 
/// Benefits:
/// - Single source of truth for dependencies
/// - Easy testing (mock dependencies)
/// - Loose coupling mellem komponenter
/// - Nem at skifte implementations
/// 
/// Usage:
/// ```dart
/// // I main.dart:
/// await setupDependencyInjection();
/// 
/// // I kode:
/// final weatherBloc = getIt<WeatherBloc>();
/// final repository = getIt<WeatherRepository>();
/// ```
final getIt = GetIt.instance;

/// Setup alle dependencies
/// 
/// Registrerer dependencies i den rigtige rækkefølge:
/// 1. Core services (ApiClient)
/// 2. Data sources
/// 3. Repositories
/// 4. BLoCs
/// 
/// Kaldes fra main.dart før app starter.
Future<void> setupDependencyInjection() async {
  // ============================================================
  // Core - API Client
  // ============================================================
  // Singleton fordi vi kun vil have én API client instance
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(),
  );

  // ============================================================
  // Data Sources
  // ============================================================
  // Remote data sources

  getIt.registerLazySingleton<EventRemoteDataSource>(
    () => EventRemoteDataSource(
      apiClient: getIt<ApiClient>(),
    ),
  );

  // Remember: Tilføj local data source her når I implementerer caching
  // getIt.registerLazySingleton<WeatherLocalDataSource>(
  //   () => WeatherLocalDataSourceImpl(),
  // );

  // ============================================================
  // Repositories
  // ============================================================
  // Registrer som interface type (WeatherRepository)
  // så BLoC kun afhænger af interface, ikke implementation

  getIt.registerLazySingleton<EventRepository>(
    () => EventRepositoryImpl(
      remoteDataSource: getIt<EventRemoteDataSource>(),
    ),
  );

  // Remember: Tilføj flere repositories her efterhånden:
  // getIt.registerLazySingleton<UserRepository>(
  //   () => UserRepositoryImpl(
  //     remoteDataSource: getIt<UserRemoteDataSource>(),
  //   ),
  // );

  // ============================================================
  // BLoCs
  // ============================================================
  // Factory fordi vi vil have ny instance hver gang
  // (BLoCs skal ikke deles mellem widgets)

  getIt.registerFactory<EventBloc>(
    () => EventBloc(
      repository: getIt<EventRepository>(),
    ),
  );

  // Remember: Tilføj flere BLoCs her efterhånden:
  // getIt.registerFactory<LoginBloc>(
  //   () => LoginBloc(
  //     authRepository: getIt<AuthRepository>(),
  //   ),
  // );
}

/// Reset dependency injection
/// 
/// Nyttigt til testing hvor du vil starte med clean slate.
/// Kan også bruges til at skifte mellem mock og real dependencies.
Future<void> resetDependencyInjection() async {
  await getIt.reset();
}

/// Setup mock dependencies til testing
/// 
/// Eksempel på hvordan I kan lave test setup:
/// ```dart
/// Future<void> setupMockDependencies() async {
///   await resetDependencyInjection();
///   
///   // Register mocks
///   getIt.registerLazySingleton<WeatherRepository>(
///     () => MockWeatherRepository(),
///   );
///   
///   getIt.registerFactory<WeatherBloc>(
///     () => WeatherBloc(repository: getIt<WeatherRepository>()),
///   );
/// }
/// ```

