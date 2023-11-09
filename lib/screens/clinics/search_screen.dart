import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql/src/core/query_result.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vetplus/models/clinic_model.dart';
import 'package:vetplus/models/procedure_model.dart';
import 'package:vetplus/providers/user_provider.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/screens/clinics/clinic_profile.dart';
import 'package:vetplus/services/clinic_service.dart';
import 'package:vetplus/services/procedure_service.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/widgets/common/long_bottom_sheet.dart';
import 'package:vetplus/widgets/common/separated_list_view.dart';
import 'package:vetplus/widgets/common/skeleton_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchEditingController = TextEditingController();
  final List<String?> _filtersList = [];
  List<bool?>? _checkedList;

  @override
  Widget build(BuildContext context) {
    bool isTablet = Responsive.isTablet(context);

    return SkeletonScreen(
      body: _buildSearchScreen(isTablet, context),
    );
  }

  Padding _buildSearchScreen(bool isTablet, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: isTablet ? 24 : 21.sp),
      child: Column(
        children: [
          _buildSearchBar(context, isTablet),
          SizedBox(height: isTablet ? 46 : 36.sp),
          FutureBuilder(
            future: ClinicService.getAllClinic(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildShimmerList(isTablet);
              } else if (snapshot.hasError) {
                return _buildErrorMessage(context);
              } else if (snapshot.data!.hasException) {
                return _buildInternetConnectionError(context);
              } else {
                final clinicsJson = snapshot.data!;
                List<ClinicModel> clinics =
                    ClinicList.fromJson(clinicsJson.data!).list;
                clinics = _sortAndFilterClinics(clinics);

                return _buildClinicListView(isTablet, clinics);
              }
            },
          )
        ],
      ),
    );
  }

  SeparatedListView _buildClinicListView(
      bool isTablet, List<ClinicModel> clinics) {
    return SeparatedListView(
      isTablet: isTablet,
      itemCount: clinics.length,
      separator: _buildListViewSeparator(isTablet),
      itemBuilder: (context, index) {
        final clinic = clinics[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, ClinicProfile.route,
                arguments: {'id': clinic.id});
          },
          child: _buildClinicItem(clinic, isTablet),
        );
      },
    );
  }

  Row _buildClinicItem(ClinicModel clinic, bool isTablet) {
    return Row(
      children: [
        _buildClinicImage(clinic, isTablet),
        SizedBox(width: isTablet ? 18 : 10.sp),
        Expanded(
          child: _buildClinicInfo(isTablet, clinic),
        ),
        SizedBox(width: isTablet ? 18 : 10.sp),
        _buildClinicRating(clinic, isTablet),
      ],
    );
  }

  Text _buildClinicRating(ClinicModel clinic, bool isTablet) {
    return Text(
      '⭐ ${clinic.clinicRating}',
      style: getSnackBarBodyStyle(isTablet)
          .copyWith(fontSize: isTablet ? 20 : 14.sp),
    );
  }

  Wrap _buildClinicInfo(bool isTablet, ClinicModel clinic) {
    return Wrap(
      runSpacing: isTablet ? 2 : 2.sp,
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            clinic.name,
            style: getSnackBarTitleStyle(isTablet),
          ),
        ),
        Text(
          clinic.address,
          style: getSnackBarBodyStyle(isTablet),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  ClipRRect _buildClinicImage(ClinicModel clinic, bool isTablet) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        clinic.image ??
            'https://preyash2047.github.io/assets/img/no-preview-available.png?h=824917b166935ea4772542bec6e8f636',
        width: isTablet ? 140 : 100.sp,
        height: isTablet ? 115 : 75.sp,
        fit: BoxFit.cover,
      ),
    );
  }

  Padding _buildListViewSeparator(bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isTablet ? 30 : 20.sp),
      child: const Divider(),
    );
  }

  List<ClinicModel> _sortAndFilterClinics(List<ClinicModel> clinics) {
    clinics.sort((a, b) => b.clinicRating!.compareTo(a.clinicRating!));

    clinics = clinics.where((element) {
      final search = _searchEditingController.text.toLowerCase();
      return element.name.toLowerCase().contains(search) ||
          element.address.toLowerCase().contains(search);
    }).toList();

    if (_filtersList.isNotEmpty) {
      clinics = clinics.where((element) {
        if (element.services != null) {
          return _filtersList.every((filter) {
            return element.services!
                .map((e) => e.toString().toLowerCase())
                .contains(filter);
          });
        } else {
          return false;
        }
      }).toList();
    }
    return clinics;
  }

  Center _buildInternetConnectionError(BuildContext context) {
    return Center(
      child: Text(AppLocalizations.of(context)!.internetConnection),
    );
  }

  Center _buildErrorMessage(BuildContext context) {
    return Center(
      child: Text(AppLocalizations.of(context)!.serverFailedBody),
    );
  }

  SearchBar _buildSearchBar(BuildContext context, bool isTablet) {
    return SearchBar(
      hintText: AppLocalizations.of(context)!.search,
      leading: Icon(
        Icons.search_outlined,
        color: Theme.of(context).colorScheme.outline,
      ),
      trailing: [
        _buildFilterIconButton(context, isTablet),
      ],
      controller: _searchEditingController,
      onChanged: (value) {
        setState(() {});
      },
    );
  }

  IconButton _buildFilterIconButton(BuildContext context, bool isTablet) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return _buildFilterSheet(isTablet);
          },
        ).then((value) => setState(() {}));
      },
      icon: Icon(
        Icons.filter_list_outlined,
        color: Theme.of(context).colorScheme.outline,
      ),
    );
  }

  FutureBuilder<QueryResult<Object?>> _buildFilterSheet(bool isTablet) {
    return FutureBuilder(
      future: ProcedureService.getAllProcedures(
          Provider.of<UserProvider>(context, listen: false).accessToken!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingIndicator();
        } else if (snapshot.hasError) {
          return FractionallySizedBox(
            heightFactor: 0.5,
            child: _buildErrorMessage(context),
          );
        } else if (snapshot.data!.hasException) {
          return FractionallySizedBox(
            heightFactor: 0.5,
            child: _buildInternetConnectionError(context),
          );
        } else {
          final servicesJson = snapshot.data!;
          List<ProcedureModel> services =
              ProcedureList.fromJson(servicesJson.data!).list;
          _checkedList = _checkedList ?? services.map((e) => false).toList();

          return _buildServiceFilterContent(isTablet, services);
        }
      },
    );
  }

  StatefulBuilder _buildServiceFilterContent(
      bool isTablet, List<ProcedureModel> services) {
    return StatefulBuilder(builder: (context, setState) {
      return LongBottomSheet(
        title: AppLocalizations.of(context)!.filters,
        buttonChild: Text(AppLocalizations.of(context)!.apply),
        btnActive: true,
        heightFactor: 0.7,
        onSubmit: () {
          Navigator.pop(context);
        },
        formRunSpacing: 0,
        children: [
          Text(
            AppLocalizations.of(context)!.services,
            style: getSectionTitle(isTablet),
          ),
          _buildServiceCheckboxes(isTablet, services, setState),
        ],
      );
    });
  }

  ListView _buildServiceCheckboxes(
      bool isTablet, List<ProcedureModel> services, StateSetter setState) {
    return ListView.separated(
      padding: EdgeInsets.only(
        top: isTablet ? 42 : 20.sp,
        bottom: isTablet ? 70 : 51.sp,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: services.length,
      separatorBuilder: (context, index) {
        return const SizedBox();
      },
      itemBuilder: (context, index) {
        return CheckboxListTile(
          title: Text(
            services[index].name,
            style: getSnackBarTitleStyle(isTablet).copyWith(
              fontWeight: FontWeight.w400,
            ),
          ),
          value: _checkedList![index],
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) {
            setState(() {
              _checkedList![index] = value;
              value!
                  ? _filtersList.add(services[index].name.toLowerCase().trim())
                  : _filtersList
                      .remove(services[index].name.toLowerCase().trim());
            });
          },
        );
      },
    );
  }

  FractionallySizedBox _buildLoadingIndicator() {
    return const FractionallySizedBox(
      heightFactor: 0.5,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildShimmerList(bool isTablet) {
    return SeparatedListView(
      isTablet: isTablet,
      itemCount: 4,
      separator: _buildListViewSeparator(isTablet),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: _buildShimmerContent(isTablet),
        );
      },
    );
  }

  Wrap _buildShimmerContent(bool isTablet) {
    return Wrap(
      spacing: isTablet ? 18 : 10.sp,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Container(
          width: 105,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.black,
          ),
        ),
        Wrap(
          direction: Axis.vertical,
          spacing: isTablet ? 2 : 2.sp,
          children: [
            Container(
              width: 100,
              height: 14,
              color: Colors.black,
            ),
            Container(
              width: 150,
              height: 12,
              color: Colors.black,
            ),
          ],
        ),
        Container(
          width: 50,
          height: 14,
          color: Colors.black,
        ),
      ],
    );
  }
}
