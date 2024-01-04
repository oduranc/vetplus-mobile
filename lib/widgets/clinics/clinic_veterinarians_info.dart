import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/models/employee_model.dart';
import 'package:vetplus/themes/typography.dart';

class ClinicVeterinariansInfo extends StatelessWidget {
  const ClinicVeterinariansInfo({
    super.key,
    required this.isTablet,
    required this.employees,
  });

  final bool isTablet;
  final List<EmployeeModel> employees;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: isTablet ? 35 : 15.sp,
      children: [
        Text(
          AppLocalizations.of(context)!.veterinarians,
          style: getClinicTitleStyle(isTablet),
        ),
        ListView.separated(
          itemCount: employees.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) =>
              Divider(height: isTablet ? 96 : 40.sp),
          itemBuilder: (context, index) {
            final employee = employees.elementAt(index).employee;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                radius: isTablet ? 32.5 : 32.5.sp,
                backgroundImage: employee.image != null
                    ? NetworkImage(employee.image!)
                    : const AssetImage('assets/images/user.png')
                        as ImageProvider,
                backgroundColor: Colors.transparent,
              ),
              title: Text(
                '${employee.names} ${employee.surnames ?? ''}',
                style: getClinicDetailsTextStyle(isTablet).copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
