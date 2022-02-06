import 'package:lab3_mis/model/notifier/persisted_user_notifier.dart';
import 'package:lab3_mis/model/notifier/user_notifier.dart';
import 'package:riverpod/riverpod.dart';

final userProvider = StateProvider<UserNotifier?>((ref) => UserNotifier());
final persistedUserProvider =
StateProvider<PersistedUserNotifier?>((ref) => PersistedUserNotifier());