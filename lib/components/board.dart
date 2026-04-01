import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tic_tac_toe_game_game/services/alert.dart';
import 'package:tic_tac_toe_game_game/theme/theme.dart';
import 'package:tic_tac_toe_game_game/services/board.dart' as board_service;
import '../services/provider.dart';
import 'o.dart';
import 'x.dart';

class Board extends StatefulWidget {
  const Board({super.key});

  @override
  BoardWidgetState createState() => BoardWidgetState();
}

class BoardWidgetState extends State<Board> {
  final boardService = locator<board_service.BoardService>();
  final alertService = locator<AlertService>();
  bool _alertShown = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<
      MapEntry<List<List<String>>, MapEntry<board_service.BoardState, String>>
    >(
      stream: Rx.combineLatest2(
        boardService.board$,
        boardService.boardState$,
        (a, b) => MapEntry(a, b),
      ),
      builder:
          (
            context,
            AsyncSnapshot<
              MapEntry<
                List<List<String>>,
                MapEntry<board_service.BoardState, String>
              >
            >
            snapshot,
          ) {
            if (!snapshot.hasData) {
              return Container();
            }

            final List<List<String>> board = snapshot.data!.key;
            final MapEntry<board_service.BoardState, String> state =
                snapshot.data!.value;

            if (state.key == board_service.BoardState.done && !_alertShown) {
              _alertShown = true;

              final String title = state.value.isEmpty ? 'Draw!' : 'Winner!';

              final Widget body = state.value == 'X'
                  ? const X(60, 20)
                  : (state.value == 'O'
                        ? const O(60, MyTheme.blue)
                        : const Row(
                            children: <Widget>[X(50, 20), O(50, MyTheme.blue)],
                          ));

              WidgetsBinding.instance.addPostFrameCallback((_) {
                Future.delayed(const Duration(milliseconds: 300), () {
                  if (!mounted) return;

                  Alert(
                    context: context,
                    title: title,
                    style: AlertStyle(
                      backgroundColor: Colors.white,
                      alertBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      titleStyle: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: MyTheme.blue,
                      ),
                      isOverlayTapDismiss:
                          alertService.resultAlertStyle.isOverlayTapDismiss,
                      isCloseButton:
                          alertService.resultAlertStyle.isCloseButton,
                      animationType:
                          alertService.resultAlertStyle.animationType,
                      animationDuration:
                          alertService.resultAlertStyle.animationDuration,
                      alertElevation:
                          alertService.resultAlertStyle.alertElevation,
                    ),
                    buttons: [],
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 24,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: MyTheme.blue.withValues(alpha: 0.08),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              body,
                              const SizedBox(height: 18),
                              Text(
                                state.value.isEmpty
                                    ? 'It\'s a Draw!'
                                    : 'Congratulations!',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: MyTheme.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    closeFunction: () {
                      _alertShown = false;
                      boardService.resetBoard();
                    },
                  ).show();
                });
              });
            }

            if (state.key == board_service.BoardState.play && _alertShown) {
              _alertShown = false;
            }

            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: MyTheme.boardBackground,
                borderRadius: BorderRadius.circular(MyTheme.radiusLarge),
                boxShadow: MyTheme.cardShadow,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: board
                    .asMap()
                    .map(
                      (i, row) => MapEntry(
                        i,
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: row
                              .asMap()
                              .map(
                                (j, item) => MapEntry(j, _buildBox(i, j, item)),
                              )
                              .values
                              .toList(),
                        ),
                      ),
                    )
                    .values
                    .toList(),
              ),
            );
          },
    );
  }

  Widget _buildBox(int i, int j, String item) {
    const double size = 80;
    final Color borderColor = MyTheme.cellBorder;

    BorderRadius borderRadius = BorderRadius.zero;
    if (i == 0 && j == 0) {
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(MyTheme.radiusMedium),
      );
    }
    if (i == 0 && j == 2) {
      borderRadius = const BorderRadius.only(
        topRight: Radius.circular(MyTheme.radiusMedium),
      );
    }
    if (i == 2 && j == 0) {
      borderRadius = const BorderRadius.only(
        bottomLeft: Radius.circular(MyTheme.radiusMedium),
      );
    }
    if (i == 2 && j == 2) {
      borderRadius = const BorderRadius.only(
        bottomRight: Radius.circular(MyTheme.radiusMedium),
      );
    }

    return GestureDetector(
      onTap: () {
        if (item != ' ') return;
        boardService.newMove(i, j);
      },
      child: AnimatedContainer(
        duration: MyTheme.animationNormal,
        decoration: BoxDecoration(
          color: MyTheme.cellBackground,
          border: Border(
            top: BorderSide(
              width: 2,
              color: i == 0 ? Colors.transparent : borderColor,
            ),
            bottom: BorderSide(
              width: 2,
              color: i == 2 ? Colors.transparent : borderColor,
            ),
            left: BorderSide(
              width: 2,
              color: j == 0 ? Colors.transparent : borderColor,
            ),
            right: BorderSide(
              width: 2,
              color: j == 2 ? Colors.transparent : borderColor,
            ),
          ),
          borderRadius: borderRadius,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        height: size,
        width: size,
        child: Center(
          child: AnimatedSwitcher(
            duration: MyTheme.animationNormal,
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: item == ' '
                ? const SizedBox.shrink()
                : item == 'X'
                ? const X(size * 0.6, 13)
                : const O(size * 0.6, MyTheme.blue),
          ),
        ),
      ),
    );
  }
}
