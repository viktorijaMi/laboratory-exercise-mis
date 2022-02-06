import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lab3_mis/model/user.dart';
import 'package:lab3_mis/providers/global_providers.dart';
import 'package:lab3_mis/service/authentication_service.dart';
import 'package:lab3_mis/ui/first_page.dart';
import 'package:lab3_mis/ui/home_page.dart';

class Wrapper extends ConsumerWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (user != null && user.state.user == null && currentRoute != '/authenticate') {
      return FirstPage();
    } else {
      return FutureBuilder<PersistedUser>(
          future: AuthenticationService().getUser(user!.user!.uid),
          builder: (context, AsyncSnapshot<PersistedUser> snapshot) {
            if (snapshot.hasData) {
              PersistedUser? persistedUser = snapshot.data;
              ref.watch(persistedUserProvider)?.setUser(persistedUser);

              return MyHomePage(title: "Student organizer app");
            } else {
              return FirstPage();
            }
          });
    }
  }
}