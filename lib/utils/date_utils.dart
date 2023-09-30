import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vetplus/models/comment_model.dart';

String formatTimePassed(
    CommentModel comment, AppLocalizations appLocalizations) {
  final time = DateTime.now().difference(DateTime.parse(comment.updatedAt));
  String timePassed;
  if (time.isNegative) {
    timePassed = appLocalizations.justNow;
  } else if (time.inSeconds < 60) {
    timePassed = '${time.inSeconds} ${appLocalizations.seconds}';
  } else if (time.inMinutes < 60) {
    timePassed = '${time.inMinutes} ${appLocalizations.minutes}';
  } else if (time.inHours < 24) {
    timePassed = '${time.inHours} ${appLocalizations.hours}';
  } else if (time.inDays < 30) {
    timePassed = '${time.inDays} ${appLocalizations.days}';
  } else if (time.inDays < 365) {
    timePassed = '${(time.inDays / 30).floor()} ${appLocalizations.months}';
  } else {
    timePassed = '${(time.inDays / 365).floor()} ${appLocalizations.years}';
  }
  return timePassed;
}
