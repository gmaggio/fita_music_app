import 'package:fita_music_app/src/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  // Search Keywords
  const artistSearch1 = 'michael jackson';
  const artistSearch2 = 'mariah';
  const artistNotFoundSearch = 'zzzzzzzz';

  // Keys
  const startIndicatorKey = Key('start-indicator');
  const notFoundIndicatorKey = Key('not-found-indicator');
  const searchFieldClearKey = Key('search-field-clear');
  const dataFetchingIndicatorKey = Key('data-fetching-indicator');
  const songTitleKey = Key('music-title');
  const songActiveIndicatorKey = Key('music-active-indicator');
  const musicPlayerKey = Key('music-player');
  const musicDetailTitleKey = Key('music-detail-title');
  const musicFetchingIndicator = Key('music-fetching-indicator');
  const musicControlPlayKey = Key('music-control-play');
  const musicControlPauseKey = Key('music-control-pause');
  const musicControlReplayKey = Key('music-control-replay');

  group(
    'Fita App Test',
    () {
      testWidgets(
        'Test the music search bar\'s functionality and searchability',
        (WidgetTester tester) async {
          await tester.pumpWidget(const MyApp());

          expect(
            find.byKey(startIndicatorKey),
            findsOneWidget,
            reason: 'The initial view should be displayed',
          );

          var textField = find.byType(TextField);
          var textFieldController =
              (textField.evaluate().first.widget as TextField).controller;

          await tester.enterText(textField, artistSearch1);
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pump();

          expect(
            find.byKey(dataFetchingIndicatorKey),
            findsOneWidget,
            reason: 'A page loader should be displayed',
          );

          await tester.pumpAndSettle(const Duration(seconds: 2));

          expect(
            tester.widgetList(find.byType(ListTile)).length,
            greaterThan(0),
            reason: 'A list of results should be found',
          );

          await tester.tap(find.byKey(searchFieldClearKey));
          await tester.pumpAndSettle(const Duration(milliseconds: 400));

          expect(
            textFieldController!.text.length,
            isZero,
            reason: 'The search bar should be cleared',
          );

          await tester.enterText(textField, artistNotFoundSearch);
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          expect(
            find.byKey(notFoundIndicatorKey),
            findsOneWidget,
            reason:
                'A message should be displayed indicating no result was found',
          );
        },
      );

      testWidgets(
        'Test the music selection process and the music player',
        (WidgetTester tester) async {
          await tester.pumpWidget(const MyApp());

          expect(
            find.byKey(startIndicatorKey),
            findsOneWidget,
            reason: 'The initial view should be displayed',
          );

          await tester.enterText(find.byType(TextField), artistSearch1);
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          var songsFound = tester.widgetList(find.byType(ListTile));

          expect(
            songsFound.length,
            greaterThan(0),
            reason: 'A list of results should be found',
          );

          var firstSong = songsFound.first;
          var firstSongKey = firstSong.key;
          var firstSongWidget = find.byKey(firstSongKey!);
          var firstSongTitleWidget = find.descendant(
            of: firstSongWidget,
            matching: find.byKey(songTitleKey),
          );
          var firstSongTitle =
              (firstSongTitleWidget.evaluate().single.widget as Text).data;

          await tester.tap(find.byWidget(firstSong));
          await tester.pump();

          expect(
            find.descendant(
              of: firstSongWidget,
              matching: find.byKey(songActiveIndicatorKey),
            ),
            findsOneWidget,
            reason:
                'An icon should be displayed in the selected music indicating '
                'the currently active song',
          );

          var musicPlayer = find.byKey(musicPlayerKey);
          var musicDetailTitleWidget = find.descendant(
            of: musicPlayer,
            matching: find.byKey(musicDetailTitleKey),
          );
          var musicDetailTitle =
              (musicDetailTitleWidget.evaluate().single.widget as Text).data;

          expect(
            musicPlayer,
            findsOneWidget,
            reason: 'The music player in the footer should be visible',
          );

          expect(
            musicDetailTitle,
            firstSongTitle,
            reason:
                'The title in the music player should be the same as the title '
                'in the selected music',
          );

          await tester.pump();

          expect(
            find.descendant(
              of: musicPlayer,
              matching: find.byKey(musicFetchingIndicator),
            ),
            findsOneWidget,
            reason: 'A music loader should be displayed in the music player',
          );

          await tester.pumpAndSettle(const Duration(seconds: 2));

          expect(
            find.descendant(
              of: musicPlayer,
              matching: find.byKey(musicControlPauseKey),
            ),
            findsOneWidget,
            reason:
                'A pause button should be displayed in the music player indicating '
                'a music is playing',
          );

          await tester.pumpAndSettle(const Duration(seconds: 15));
          await tester.tap(find.byKey(musicControlPauseKey));
          await tester.pump();

          expect(
            find.byKey(musicControlPlayKey),
            findsOneWidget,
            reason:
                'A play button should be displayed in the music player indicating '
                'a music is paused',
          );

          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          await tester.tap(find.byKey(musicControlPlayKey));
          await tester.pumpAndSettle(const Duration(seconds: 15));

          expect(
            find.byKey(musicControlReplayKey),
            findsOneWidget,
            reason:
                'A replay button should be displayed in the music player indicating '
                'the music has reached the end',
          );

          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          await tester.tap(find.byKey(musicControlReplayKey));
          await tester.pumpAndSettle(const Duration(milliseconds: 500));

          expect(
            find.byKey(musicControlPauseKey),
            findsOneWidget,
            reason:
                'A pause button should be displayed in the music player indicating '
                'a music is playing again from the start',
          );

          var textField = find.byType(TextField);

          await tester.tap(find.byKey(searchFieldClearKey));
          await tester.enterText(textField, artistSearch2);
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          expect(
            firstSongWidget,
            findsNothing,
            reason:
                'The music from the previous search should not be available',
          );

          expect(
            tester.widgetList(find.byType(ListTile)).length,
            greaterThan(0),
            reason: 'A list of new results should be found',
          );

          expect(
            musicPlayer,
            findsOneWidget,
            reason: 'The music player in the footer should still be visible',
          );

          expect(
            musicDetailTitle,
            firstSongTitle,
            reason:
                'The title in the music player should still be the same as the title '
                'in the previous selected music',
          );

          await tester.pumpAndSettle(const Duration(seconds: 2));
        },
      );
    },
  );
}
