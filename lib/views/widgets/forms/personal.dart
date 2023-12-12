import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_school/extensions/formatters/first_letter.dart';
import 'package:web_school/models/application/personal.dart';
import 'package:web_school/models/option.dart';
import 'package:web_school/networks/application.dart';
import 'package:web_school/networks/commons.dart';
import 'package:web_school/values/strings/colors.dart';
import 'package:web_school/views/widgets/buttons/dropdown.dart';
import 'package:web_school/views/widgets/fields/dropdown.dart';
import 'package:web_school/views/widgets/fields/primary.dart';

class BasicPersonalInfoForm extends StatefulWidget {
  const BasicPersonalInfoForm({
    this.viewOnly = false,
    this.personalInfo,
    super.key,
  });

  final bool viewOnly;
  final PersonalInfo? personalInfo;

  @override
  State<BasicPersonalInfoForm> createState() => _BasicPersonalInfoFormState();
}

class _BasicPersonalInfoFormState extends State<BasicPersonalInfoForm> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Application application =
          Provider.of<Application>(context, listen: false);

      if (widget.viewOnly) {
        setState(() {
          final PersonalInfo personalInfo = widget.personalInfo!;
          application.hasLRN = personalInfo.hasLrn;
          Application.learningReferenceNumber.text = personalInfo.lrn;
          Application.lastName.text = personalInfo.lastName;
          Application.firstName.text = personalInfo.firstName;
          Application.middleName.text = personalInfo.middleName;
          Application.extensionName.text = personalInfo.extensionName;
          Application.placeOfBirth.text = personalInfo.placeOfBirth;
          Application.dateOfBirth.text = personalInfo.dateOfBirth;
          Application.age.text = personalInfo.age;
          application.gender = personalInfo.gender;
          application.isIndigenousPeople = personalInfo.isIndigenous;
          Application.motherTounge.text = personalInfo.motherTounge;
          Application.otherLanguages.text = personalInfo.otherLanguage;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Application application = Provider.of<Application>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 24.0),
        Text(
          "B. LEARNER INFORMATION",
          style: theme.textTheme.bodyLarge,
        ),

        const SizedBox(height: 12.0),
        Text(
          "B.1. Basic Personal Information",
          style: theme.textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12.0),
        widget.viewOnly
            ? PrimaryTextField(
                controller:
                    TextEditingController(text: application.hasLRN?.label),
                label: "Learning References Number (LRN)",
                readOnly: widget.viewOnly,
              )
            : CustomDropdown<SelectionOption>(
                initialValue: application.hasLRN,
                value: application.hasLRN,
                label: "Learning References Number (LRN)",
                hintText: 'Select',
                items: application.agreeDisagree.map((SelectionOption option) {
                  return SchoolDropdownMenuItem<SelectionOption>(
                    value: option,
                    label: option.label!,
                    child: SchoolDropdown(
                      option: option,
                    ),
                  );
                }).toList(),
                enabled: !widget.viewOnly,
                onChanged: application.updateHasLRN,
                validator: Commons.forcedDropdownValidator,
              ),

        Visibility(
          visible: application.hasLRN?.label == "Yes",
          child: PrimaryTextField(
            fieldKey: Application.learningReferenceNumberKey,
            controller: Application.learningReferenceNumber,
            hintText: "Enter your assigned LRN",
            label: "Learning Reference Number (LRN)",
            validator: Commons.forcedTextValidator,
            readOnly: widget.viewOnly,
          ),
        ),
        const SizedBox(height: 12.0),
        Text(
          "Write the name as it spelled in the NSA Birth Certificate.",
          style: theme.textTheme.bodyMedium!.copyWith(
            color: ColorTheme.primaryRed,
          ),
        ),

        PrimaryTextField(
          fieldKey: Application.lastNameKey,
          controller: Application.lastName,
          hintText: "Last name",
          label: "Last name",
          validator: Commons.forcedTextValidator,
          readOnly: widget.viewOnly,
          onChanged: (value) {
            if (value.isNotEmpty) {
              Application.lastName.value = Application.lastName.value.copyWith(
                text: value[0].toUpperCase() + value.substring(1),
              );
            }
          },
        ),

        PrimaryTextField(
          fieldKey: Application.firstNameKey,
          controller: Application.firstName,
          hintText: "First name",
          label: "First name",
          validator: Commons.forcedTextValidator,
          inputFormatters: [
            FirstLetterUppercaseTextFormatter(),
          ],
          readOnly: widget.viewOnly,
          onChanged: (value) {
            if (value.isNotEmpty) {
              Application.firstName.value = Application.firstName.value.copyWith(
                text: value[0].toUpperCase() + value.substring(1),
              );
            }
          },
        ),

        PrimaryTextField(
          fieldKey: Application.middleNameKey,
          controller: Application.middleName,
          hintText: "Middle name",
          label: "Middle name",
          validator: Commons.forcedTextValidator,
          inputFormatters: [
            FirstLetterUppercaseTextFormatter(),
          ],
          readOnly: widget.viewOnly,
          onChanged: (value) {
            if (value.isNotEmpty) {
              Application.middleName.value = Application.middleName.value.copyWith(
                text: value[0].toUpperCase() + value.substring(1),
              );
            }
          },
        ),

        PrimaryTextField(
          fieldKey: Application.extensionNameKey,
          controller: Application.extensionName,
          hintText: "Extension name e.g. Jr.(if applicable) Type \"none\" if none",
          label: "Extension name e.g. Jr.(if applicable)",
          validator: Commons.forcedTextValidator,
          readOnly: widget.viewOnly,

        ),

        PrimaryTextField(
          fieldKey: Application.placeOfBirthKey,
          controller: Application.placeOfBirth,
          hintText: "Place of Birth",
          label: "Place of Birth",
          validator: Commons.forcedTextValidator,
          inputFormatters: [
            FirstLetterUppercaseTextFormatter(),
          ],
          readOnly: widget.viewOnly,
          onChanged: (value) {
            if (value.isNotEmpty) {
              Application.placeOfBirth.value = Application.placeOfBirth.value.copyWith(
                text: value[0].toUpperCase() + value.substring(1),
              );
            }
          },
        ),

        PrimaryTextField(
          fieldKey: Application.dateOfBirthKey,
          controller: Application.dateOfBirth,
          hintText: "Enter",
          label: "Date of Birth",
          readOnly: true,
          onTap: () => widget.viewOnly ? null : application.updateBirthDate(context),
        ),

        PrimaryTextField(
          fieldKey: Application.ageKey,
          controller: Application.age,
          hintText: "Enter",
          label: "Age (today)",
          validator: Commons.forcedTextValidator,
          readOnly: widget.viewOnly,
        ),

        const SizedBox(height: 12.0),

        widget.viewOnly
            ? PrimaryTextField(
                controller:
                    TextEditingController(text: application.gender?.label),
                label: "Gender",
                readOnly: widget.viewOnly,
              )
            : CustomDropdown<SelectionOption>(
                initialValue: application.gender,
                value: application.gender,
                label: "Gender",
                hintText: 'Select',
                items: application.genderList.map((SelectionOption option) {
                  return SchoolDropdownMenuItem<SelectionOption>(
                    value: option,
                    label: option.label!,
                    child: SchoolDropdown(
                      option: option,
                    ),
                  );
                }).toList(),
                onChanged: application.updateGender,
                validator: Commons.forcedDropdownValidator,
              ),

        const SizedBox(height: 12.0),

        widget.viewOnly
            ? PrimaryTextField(
                controller: TextEditingController(
                    text: application.isIndigenousPeople?.label),
                label: "Belong to Indigenous People",
                readOnly: widget.viewOnly,
              )
            : CustomDropdown<SelectionOption>(
                initialValue: application.isIndigenousPeople,
                value: application.isIndigenousPeople,
                label: "Belong to Indigenous People",
                hintText: 'Select',
                items: application.agreeDisagree.map((SelectionOption option) {
                  return SchoolDropdownMenuItem<SelectionOption>(
                    value: option,
                    label: option.label!,
                    child: SchoolDropdown(
                      option: option,
                    ),
                  );
                }).toList(),
                onChanged: application.updateIsIndigenousPeople,
                validator: Commons.forcedDropdownValidator,
              ),
        //
        // Visibility(
        //   visible: application.isIndigenousPeople,
        //   child: PrimaryTextField(
        //     fieldKey: Application.indigenousGroupKey,
        //     controller: Application.indigenousGroup,
        //     hintText: "Indigenous Group",
        //     label: "Others (Specify)",
        //   ),
        // ),

        PrimaryTextField(
          fieldKey: Application.motherToungeKey,
          controller: Application.motherTounge,
          hintText: "Enter",
          label: "Mother Tounge",
          validator: Commons.forcedTextValidator,
          readOnly: widget.viewOnly,
          onChanged: (value) {
            if (value.isNotEmpty) {
              Application.motherTounge.value = Application.motherTounge.value.copyWith(
                text: value[0].toUpperCase() + value.substring(1),
              );
            }
          },
        ),

        PrimaryTextField(
          fieldKey: Application.otherLanguagesKey,
          controller: Application.otherLanguages,
          hintText: "Enter",
          label: "Other Languages Spoken",
          readOnly: widget.viewOnly,
          inputFormatters: [
            FirstLetterUppercaseTextFormatter(),
          ],
          onChanged: (value) {
            if (value.isNotEmpty) {
              Application.otherLanguages.value = Application.otherLanguages.value.copyWith(
                text: value[0].toUpperCase() + value.substring(1),
              );
            }
          },
        ),
      ],
    );
  }
}
