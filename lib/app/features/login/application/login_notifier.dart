import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:on_stage_app/app/analytics/analytics_service.dart';
import 'package:on_stage_app/app/analytics/enums/login_method.dart';
import 'package:on_stage_app/app/database/app_database.dart';
import 'package:on_stage_app/app/features/login/application/login_state.dart';
import 'package:on_stage_app/app/features/login/data/login_repository.dart';
import 'package:on_stage_app/app/features/login/domain/login_request_model.dart';
import 'package:on_stage_app/app/features/team/application/team_notifier.dart';
import 'package:on_stage_app/app/features/team_member/application/current_team_member/current_team_member_notifier.dart';
import 'package:on_stage_app/app/features/team_member/application/team_members_notifier.dart';
import 'package:on_stage_app/app/features/user/application/user_notifier.dart';
import 'package:on_stage_app/app/features/user_settings/application/user_settings_notifier.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

part 'login_notifier.g.dart';

@Riverpod(keepAlive: true)
class LoginNotifier extends _$LoginNotifier {
  LoginRepository? _loginRepository;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  LoginRepository get loginRepository {
    _loginRepository ??= LoginRepository(ref.read(dioProvider));
    return _loginRepository!;
  }

  @override
  LoginState build() {
    _checkLoggedInStatus();
    return const LoginState(isLoading: true);
  }

  void init() {
    unawaited(_checkLoggedInStatus());
    logger.i('init login provider state');
  }

  // Check if the user is logged in by checking if a token exists.
  Future<void> _checkLoggedInStatus() async {
    final token = await _secureStorage.read(key: 'token');
    if (token != null) {
      state = state.copyWith(
        isLoggedIn: true,
        isLoading: false,
      ); // User is logged in
      logger.i('User is logged in with a valid token');
    } else {
      state = state.copyWith(
        isLoggedIn: false,
        isLoading: false,
      ); // No token, user is logged out
      logger.i('No valid token found. User is not logged in');
    }
  }

  Future<bool> signUpWithCredentials(
    String name,
    String email,
    String password,
  ) async {
    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;

      if (user != null) {
        await user.updateDisplayName(name);
        final idToken = await user.getIdToken();
        if (idToken == null) {
          throw Exception('Failed to get ID Token');
        }
        await _login(idToken);

        return true;
      }

      return false;
    } on FirebaseAuthException catch (e) {
      logger.e('Failed to sign up with credentials: ${e.code}, ${e.message}');
      return false;
    } catch (e, s) {
      logger.e('Failed to sign up with credentials: $e, $s');
      return false;
    }
  }

  Future<bool> signInWithEmail(String email, String password) async {
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;

      if (user != null) {
        final idToken = await user.getIdToken();
        if (idToken == null) {
          throw Exception('Failed to get ID Token');
        }
        await _login(idToken);

        state = state.copyWith(isLoggedIn: true);
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      logger.e('Failed to login with credentials: ${e.code}, ${e.message}');
      state = LoginState(error: e.message ?? 'Authentication failed');
      return false;
    } catch (e, s) {
      logger.e('Failed to login with credentials: $e, $s');
      state = LoginState(
        error: e.toString(),
      );
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return false;
      }

      final googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final idToken = await user.getIdToken();
        if (idToken == null) {
          throw Exception('Failed to get ID Token');
        }
        await _login(idToken);

        _setLoginMethodForAnalytics(LoginMethod.google);

        state = state.copyWith(isLoggedIn: true);
        return true;
      }
      return false;
    } catch (e, s) {
      logger.e('Failed to sign in with Google: $e, $s');
      state = LoginState(error: e.toString());
      return false;
    }
  }

  void _setLoginMethodForAnalytics(LoginMethod loginMethod) {
    unawaited(
      ref.read(analyticsServiceProvider.notifier).logLogin(loginMethod.name),
    );
  }

  Future<bool> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      final user = userCredential.user;

      if (user != null) {
        final idToken = await user.getIdToken();
        if (idToken == null) {
          throw Exception('Failed to get ID Token');
        }
        await _login(idToken);
        _setLoginMethodForAnalytics(LoginMethod.apple);
        state = state.copyWith(isLoggedIn: true);
        return true;
      }
      return false;
    } catch (e, s) {
      logger.e('Failed to sign in with Apple: $e, $s');
      state = LoginState(error: e.toString());
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();

      await _secureStorage.delete(key: 'token');

      state = const LoginState();
      ref
        ..invalidate(userNotifierProvider)
        ..invalidate(teamNotifierProvider)
        ..invalidate(teamMembersNotifierProvider)
        ..invalidate(userSettingsNotifierProvider)
        ..invalidate(databaseProvider)
        ..invalidate(currentTeamMemberNotifierProvider);

      logger.i('User signed out successfully');
    } catch (e, s) {
      logger.e('Failed to sign out: $e, $s');
      state = LoginState(error: e.toString());
    }
  }

  Future<void> _login(String idToken) async {
    state = state.copyWith(isLoading: true);

    final authToken = await loginRepository.login(
      LoginRequest(firebaseToken: idToken),
    );
    await _saveAuthToken(authToken as String);
    state = state.copyWith(isLoading: false);
  }

  Future<void> _saveAuthToken(String authToken) async {
    try {
      await _secureStorage.write(key: 'token', value: authToken);
      logger.i('Auth token saved successfully');
    } catch (e) {
      logger.e('Failed to save auth token: $e');
    }
  }
}
