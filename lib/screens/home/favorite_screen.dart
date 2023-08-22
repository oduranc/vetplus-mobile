import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/widgets/common/skeleton_screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});
  static const route = 'favorites';

  @override
  Widget build(BuildContext context) {
    bool isTablet = Responsive.isTablet(context);

    return SkeletonScreen(
      providedPadding: EdgeInsets.symmetric(
        horizontal: isTablet ? 37 : 24.sp,
        vertical: isTablet ? 60 : 35.sp,
      ),
      appBar: AppBar(
        title: Text('Favoritos'),
        centerTitle: false,
      ),
      body: ListView.separated(
        shrinkWrap: true,
        itemCount: 2,
        itemBuilder: (context, index) {
          return Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://preyash2047.github.io/assets/img/no-preview-available.png?h=824917b166935ea4772542bec6e8f636',
                  width: isTablet ? 140 : 100.sp,
                ),
              ),
              SizedBox(
                width: isTablet ? 18 : 10.sp,
              ),
              Expanded(
                child: Wrap(
                  runSpacing: isTablet ? 2 : 2.sp,
                  children: [
                    Text('Centro veterinario',
                        style: getSnackBarTitleStyle(isTablet)),
                    Text(
                      'La Trinitaria, Santiago',
                      style: getSnackBarBodyStyle(isTablet),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.white,
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 41, right: 24, left: 24),
                        child: Wrap(
                          runSpacing: 22,
                          children: [
                            const Divider(
                              indent: 100,
                              endIndent: 100,
                              thickness: 4,
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              child: Text('Eliminar de favoritos'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor:
                                    Theme.of(context).colorScheme.error,
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              child: Text('Cancelar'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.more_horiz),
              ),
            ],
          );
        },
        separatorBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: isTablet ? 30 : 20.sp),
            child: Divider(),
          );
        },
      ),
    );
  }
}
