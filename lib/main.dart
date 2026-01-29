import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:price_alert/core/constants/storage_constants.dart';
import 'package:price_alert/core/network/dio_client.dart';
import 'package:price_alert/core/network/network_info.dart';
import 'package:price_alert/core/theme/app_theme.dart';
import 'package:price_alert/features/auth/data/datasources/auth_locale_datasource.dart';
import 'package:price_alert/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:price_alert/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:price_alert/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:price_alert/features/auth/domain/usecases/login_usecase.dart';
import 'package:price_alert/features/auth/domain/usecases/logout_usecase.dart';
import 'package:price_alert/features/auth/domain/usecases/register_usecase.dart';
import 'package:price_alert/features/auth/domain/usecases/send_password_reset_email_usecase.dart';
import 'package:price_alert/features/auth/presentation/pages/splash_page.dart';
import 'package:price_alert/features/auth/presentation/providers/auth_provider.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Hive.initFlutter();

  final userBox = await Hive.openBox(StorageConstants.userBoxName);

  final firebaseAuth = FirebaseAuth.instance;
  final connectivity = Connectivity();
  final dioClient = DioClient();

  final networkInfo = NetworkInfoImpl(connectivity);

  final authRemoteDataSource = AuthRemoteDataSourceImpl(
    firebaseAuth: firebaseAuth,
  );

  final authLocalDataSource = AuthLocalDataSourceImpl(userBox: userBox);

  final authRepository = AuthRepositoryImpl(
    remoteDataSource: authRemoteDataSource,
    localDataSource: authLocalDataSource,
    networkInfo: networkInfo,
  );

  final loginUseCase = LoginUseCase(authRepository);
  final registerUseCase = RegisterUsecase(authRepository);
  final logoutUseCase = LogoutUsecase(authRepository);
  final getCurrentUserUseCase = GetCurrentUserUsecase(authRepository);
  final sendPasswordResetEmailUseCase = SendPasswordResetEmailUsecase(
    authRepository,
  );

  runApp(
    ProviderScope(
      overrides: [
        authNotifierProvider.overrideWith(
          (ref) => AuthNotifier(
            loginUseCase: loginUseCase,
            registerUseCase: registerUseCase,
            logoutUseCase: logoutUseCase,
            getCurrentUserUseCase: getCurrentUserUseCase,
            sendPasswordResetEmailUseCase: sendPasswordResetEmailUseCase,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Price Alert',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const SplashPage(),
    );
  }
}
