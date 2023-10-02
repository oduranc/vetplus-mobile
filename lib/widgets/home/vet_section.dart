import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:vetplus/models/clinic_model.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/widgets/home/vet_list_item.dart';

class VetSection extends StatelessWidget {
  const VetSection({
    Key? key,
    required this.sectionTitle,
    required this.shimmerEffect,
    required this.snapshot,
  }) : super(key: key);

  final String sectionTitle;
  final Widget shimmerEffect;
  final AsyncSnapshot<QueryResult<Object?>> snapshot;

  @override
  Widget build(BuildContext context) {
    bool isTablet = Responsive.isTablet(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(sectionTitle, style: getSectionTitle(isTablet)),
        SizedBox(height: isTablet ? 14 : 14.sp),
        _buildClinicsListView(isTablet),
      ],
    );
  }

  SizedBox _buildClinicsListView(bool isTablet) {
    return SizedBox(
      height: isTablet ? 200 : 150.sp,
      child: Builder(
        builder: (context) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerList(isTablet);
          } else if (snapshot.hasError) {
            return Center(
              child: Text(AppLocalizations.of(context)!.serverFailedBody),
            );
          } else if (snapshot.data!.hasException) {
            return Center(
              child: Text(AppLocalizations.of(context)!.internetConnection),
            );
          } else {
            final clinicsJson = snapshot.data!;
            List<ClinicModel> clinics =
                ClinicList.fromJson(clinicsJson.data!).list;

            _sortClinics(context, clinics);

            return _buildClinicsList(isTablet, clinics);
          }
        },
      ),
    );
  }

  void _sortClinics(BuildContext context, List<ClinicModel> clinics) {
    if (sectionTitle == AppLocalizations.of(context)!.topRated) {
      clinics.sort(_compareTopRatedClinics);
    }
    if (sectionTitle == AppLocalizations.of(context)!.trending) {
      clinics.sort(_compareTrendingClinics);
    }
    if (sectionTitle == AppLocalizations.of(context)!.discover) {
      clinics.sort(_compareDiscoverClinics);
    }
  }

  ListView _buildClinicsList(bool isTablet, List<ClinicModel> clinics) {
    return ListView.separated(
      separatorBuilder: (context, index) =>
          SizedBox(width: isTablet ? 30 : 20.sp),
      itemCount: clinics.length,
      itemBuilder: (context, index) {
        return VetListItem(isTablet: isTablet, clinic: clinics[index]);
      },
      padding: EdgeInsets.only(right: isTablet ? 37 : 24.sp),
      scrollDirection: Axis.horizontal,
    );
  }

  ListView _buildShimmerList(bool isTablet) {
    return ListView.separated(
      separatorBuilder: (context, index) =>
          SizedBox(width: isTablet ? 30 : 20.sp),
      itemCount: 4,
      padding: EdgeInsets.only(right: isTablet ? 37 : 24.sp),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return shimmerEffect;
      },
    );
  }

  int _compareDiscoverClinics(a, b) {
    final totalUsersComparison = a.clinicSummaryScore.totalUsers
        .compareTo(b.clinicSummaryScore.totalUsers);

    if (totalUsersComparison == 0) {
      return a.clinicRating.compareTo(b.clinicRating);
    }

    return totalUsersComparison;
  }

  int _compareTrendingClinics(a, b) => b.clinicSummaryScore.totalUsers
      .compareTo(a.clinicSummaryScore.totalUsers);

  int _compareTopRatedClinics(a, b) {
    final clinicRatingComparison = b.clinicRating.compareTo(a.clinicRating);

    if (clinicRatingComparison == 0) {
      return b.clinicSummaryScore.totalUsers
          .compareTo(a.clinicSummaryScore.totalUsers);
    }

    return clinicRatingComparison;
  }
}
