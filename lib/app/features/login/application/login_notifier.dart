import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:on_stage_app/app/features/login/application/login_state.dart';
import 'package:on_stage_app/app/features/login/data/login_repository.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_notifier.g.dart';

@Riverpod(keepAlive: true)
class LoginNotifier extends _$LoginNotifier {
  late final LoginRepository _loginRepository;

  @override
  LoginState build() {
    final dio = Dio(); // Configure Dio as needed
    _loginRepository = LoginRepository(dio);
    return const LoginState();
  }

  Future<void> init() async {
    logger.i('init login provider state');
  }

  Future<void> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return;
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
        logger.i('ID Token: $idToken');
      }
    } catch (e, s) {
      logger.e('Failed to sign in with Google: $e, $s');
      state = LoginState(error: e.toString());
    }
  }
}
