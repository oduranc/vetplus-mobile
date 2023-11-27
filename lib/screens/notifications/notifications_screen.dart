import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vetplus/models/notification_model.dart';
import 'package:vetplus/providers/user_provider.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/screens/appointments/item_shimmer.dart';
import 'package:vetplus/services/notification_service.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/widgets/common/buttons_bottom_sheet.dart';
import 'package:vetplus/widgets/common/separated_list_view.dart';
import 'package:vetplus/widgets/common/skeleton_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    bool isTablet = Responsive.isTablet(context);

    return SkeletonScreen(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.notifications)),
      body: Padding(
        padding: EdgeInsets.only(top: isTablet ? 37 : 24.sp),
        child: FutureBuilder(
            future: NotificationService.getAllNotifications(
                Provider.of<UserProvider>(context, listen: false).accessToken!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ItemShimmer(isTablet: isTablet);
              } else if (snapshot.hasError) {
                return Text(AppLocalizations.of(context)!.internetConnection);
              } else if (snapshot.data!.hasException) {
                return Text(AppLocalizations.of(context)!.internetConnection);
              } else {
                final notificationsJson = snapshot.data!;
                List<NotificationModel> notifications =
                    NotificationList.fromJson(notificationsJson.data!).list;
                return SeparatedListView(
                  isTablet: isTablet,
                  itemCount: notifications.length,
                  separator: const Divider(),
                  itemBuilder: (context, index) {
                    final title = notifications[index].title.toLowerCase();
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        radius: isTablet ? (55 / 2) : (45 / 2).sp,
                        foregroundColor: Colors.white,
                        backgroundColor: !notifications[index].read
                            ? const Color(0xFF6EC6EB)
                            : Theme.of(context).colorScheme.outlineVariant,
                        child: Icon(Icons.event_outlined,
                            size: isTablet ? 30 : 20),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${title.replaceFirst(title[0], title[0].toUpperCase())} ',
                            style: getBottomSheetTitleStyle(isTablet)
                                .copyWith(height: 0, letterSpacing: 0.16),
                            textAlign: TextAlign.justify,
                          ),
                          SizedBox(height: isTablet ? 6 : 2.sp),
                          Text(
                            notifications[index].subtitle,
                            style: getBottomSheetBodyStyle(isTablet),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                      trailing: notifications[index].read
                          ? null
                          : IconButton(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onInverseSurface,
                              onPressed: () {
                                buildDangerModal(context, notifications[index]);
                              },
                              icon: const Icon(Icons.more_horiz),
                            ),
                    );
                  },
                );
              }
            }),
      ),
    );
  }

  Future<dynamic> buildDangerModal(
      BuildContext context, NotificationModel notification) {
    return showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return ButtonsBottomSheet(
            children: [
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        setState(() {
                          _isLoading = true;
                        });
                        await NotificationService.markNotificationAsRead(
                          Provider.of<UserProvider>(context, listen: false)
                              .accessToken!,
                          notification.id,
                        ).then((value) {
                          Navigator.pop(context);
                        });
                        setState(() {
                          _isLoading = false;
                        });
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Theme.of(context).colorScheme.error,
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      )
                    : Text(AppLocalizations.of(context)!.markNotification),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
            ],
          );
        });
      },
    );
  }
}
