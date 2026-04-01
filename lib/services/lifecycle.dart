// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:tic_tac_toe_game_game/services/provider.dart';
import 'package:tic_tac_toe_game_game/services/stoppable_service.dart';
import 'package:tic_tac_toe_game_game/services/sound.dart';

class LifeCycleManager extends StatefulWidget {
  final Widget child;

  const LifeCycleManager({super.key, required this.child});

  @override
  _LifeCycleManagerState createState() => _LifeCycleManagerState();
}

class _LifeCycleManagerState extends State<LifeCycleManager>
    with WidgetsBindingObserver {
  //Monitor the AppLifeCycle Constantly
  List<StoppableService> servicesToManager = [
    locator<SoundService>(),
  ]; //loop through all the services to stop/resume them
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // print('state = $state');
    super.didChangeAppLifecycleState(state);
    for (var service in servicesToManager) {
      if (state == AppLifecycleState.resumed) {
        //app is opened again
        service.start();
      } else {
        service.stop(); //remain dormant
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.child,
    );
  }
}
