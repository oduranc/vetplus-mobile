import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/utils/validation_utils.dart';
import 'package:vetplus/widgets/common/custom_calendar.dart';
import 'package:vetplus/widgets/common/custom_form_field.dart';
import 'package:vetplus/widgets/common/read_only_form_field.dart';

ReadOnlyFormField buildPetBreedFormField(
  BuildContext context,
  TextEditingController breedController,
  VoidCallback onTap,
) {
  return ReadOnlyFormField(
    validator: (value) {
      return validateBreed(value, context);
    },
    labelText: AppLocalizations.of(context)!.breed,
    controller: breedController,
    onTap: onTap,
  );
}

DropdownButtonFormField<int> buildPetSpecieFormField(
    BuildContext context, void Function(int?)? onChanged) {
  return DropdownButtonFormField(
    validator: (value) {
      return validateSpecie(value, context);
    },
    decoration:
        InputDecoration(label: Text(AppLocalizations.of(context)!.specie)),
    items: [
      DropdownMenuItem(
        value: 1,
        child: Text(AppLocalizations.of(context)!.dog),
      ),
      DropdownMenuItem(
        value: 2,
        child: Text(AppLocalizations.of(context)!.cat),
      ),
    ],
    onChanged: onChanged,
  );
}

DropdownButtonFormField<String> buildPetGenderFormField(
    BuildContext context, void Function(String?)? onChanged, String? value) {
  return DropdownButtonFormField(
    validator: (value) {
      return validateSex(value, context);
    },
    decoration: InputDecoration(label: Text(AppLocalizations.of(context)!.sex)),
    value: value,
    items: [
      DropdownMenuItem(
        value: 'M',
        child: Text(AppLocalizations.of(context)!.male),
      ),
      DropdownMenuItem(
        value: 'F',
        child: Text(AppLocalizations.of(context)!.female),
      ),
    ],
    onChanged: onChanged,
  );
}

class PetNameFormField extends StatelessWidget {
  const PetNameFormField({
    super.key,
    required TextEditingController nameController,
  }) : _nameController = nameController;

  final TextEditingController _nameController;

  @override
  Widget build(BuildContext context) {
    return CustomFormField(
      keyboardType: TextInputType.name,
      labelText: AppLocalizations.of(context)!.nameText,
      controller: _nameController,
      validator: (value) {
        return validateName(value, context);
      },
    );
  }
}

SizedBox buildCalendar(bool isTablet, DateTime now, DateTime minDate,
    DateTime? initialDate, void Function(dynamic) onChanged) {
  return SizedBox(
    height: isTablet ? 409 : 356.sp,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Divider(),
        CustomCalendar(
          now: now,
          minDate: minDate,
          initialDate: initialDate ?? DateTime(now.year, now.month, now.day),
          isTablet: isTablet,
          onChanged: onChanged,
        ),
      ],
    ),
  );
}

ReadOnlyFormField buildPetDobFormField(BuildContext context,
    TextEditingController datePickerController, VoidCallback onTap) {
  return ReadOnlyFormField(
    controller: datePickerController,
    labelText: AppLocalizations.of(context)!.dateOfBirth,
    onTap: onTap,
  );
}

DropdownButtonFormField<bool> buildPetCastratedFormField(
    BuildContext context, void Function(bool?)? onChanged, bool? value) {
  return DropdownButtonFormField(
    validator: (value) {
      return validateCastrated(value, context);
    },
    decoration:
        InputDecoration(label: Text(AppLocalizations.of(context)!.castrated)),
    value: value,
    items: [
      DropdownMenuItem(
        value: true,
        child: Text(AppLocalizations.of(context)!.yes),
      ),
      const DropdownMenuItem(
        value: false,
        child: Text('No'),
      ),
    ],
    onChanged: onChanged,
  );
}
