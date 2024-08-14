import 'package:auth_with_shared/auth/auth_bloc.dart';
import 'package:auth_with_shared/auth/auth_service.dart';
import 'package:auth_with_shared/repo/auth_repo.dart';
import 'package:auth_with_shared/ui/screens/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  final authRepository = AuthRepository(authService: AuthService());

  runApp(
    BlocProvider(
      create: (context) => AuthBloc(authRepository: authRepository),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: App(),
      ),
    ),
  );
}
