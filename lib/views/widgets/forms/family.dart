import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:web_school/extensions/formatters/first_letter.dart';
import 'package:web_school/models/application/family.dart';
import 'package:web_school/models/option.dart';
import 'package:web_school/networks/application.dart';
import 'package:web_school/networks/commons.dart';
import 'package:web_school/views/widgets/buttons/dropdown.dart';
import 'package:web_school/views/widgets/fields/dropdown.dart';
import 'package:web_school/views/widgets/fields/primary.dart';

class FamilyInformationForm extends StatefulWidget {
  const FamilyInformationForm({
    this.familyInfo,
    this.viewOnly = false,
    super.key,
  });

  final FamilyInfo? familyInfo;
  final bool viewOnly;

  @override
  State<FamilyInformationForm> createState() => _FamilyInformationFormState();
}

class _FamilyInformationFormState extends State<FamilyInformationForm> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Application application =
          Provider.of<Application>(context, listen: false);

      if (widget.viewOnly) {
        setState(() {
            final FamilyInfo familyInfo = widget.familyInfo!;
        application.responsible = familyInfo.responsible;
        application.status = familyInfo.parentStatus;
        Application.numberOfBrother.text = familyInfo.numberOfBrother;
        Application.numberOfSister.text = familyInfo.numberOfSister;
        Application.birthOrder.text = familyInfo.birthNumber;
        application.is4psBeneficiary = familyInfo.beneficiary;
        Application.whenBeneficiary.text = familyInfo.whenBeneficiary;
        Application.firstNamePrinted.text = familyInfo.firstName;
        Application.middleNamePrinted.text = familyInfo.middleName;
        Application.lastNamePrinted.text = familyInfo.lastName;
        Application.learnerRelation.text = familyInfo.relationship;
        Application.dateEntered.text = familyInfo.dateEntered;
        });
      
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Application application = Provider.of<Application>(context);
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 12.0,
        ),
        Text(
          "C. Family Information",
          style: theme.textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12.0),
        widget.viewOnly
            ? PrimaryTextField(
                controller:
                    TextEditingController(text: application.responsible?.label),
                label:
                    "Person’s mainly responsible for taking care of learner of this school year",
                readOnly: widget.viewOnly,
              )
            : CustomDropdown<SelectionOption>(
                initialValue: application.responsible,
                value: application.responsible,
                label:
                    "Person’s mainly responsible for taking care of learner of this school year.",
                hintText: 'Select',
                items:
                    application.responsibleList.map((SelectionOption option) {
                  return SchoolDropdownMenuItem<SelectionOption>(
                    value: option,
                    label: option.label!,
                    child: SchoolDropdown(
                      option: option,
                    ),
                  );
                }).toList(),
                onChanged: application.updateResponsible,
                validator: Commons.forcedDropdownValidator,
              ),
        widget.viewOnly
            ? PrimaryTextField(
                controller:
                    TextEditingController(text: application.status?.label),
                label: "Status of Parents",
                readOnly: widget.viewOnly,
              )
            : CustomDropdown<SelectionOption>(
                initialValue: application.status,
                value: application.status,
                label: "Status of Parents",
                hintText: 'Select',
                items: application.statusList.map((SelectionOption option) {
                  return SchoolDropdownMenuItem<SelectionOption>(
                    value: option,
                    label: option.label!,
                    child: SchoolDropdown(
                      option: option,
                    ),
                  );
                }).toList(),
                onChanged: application.updateStatus,
                validator: Commons.forcedDropdownValidator,
              ),
        const SizedBox(height: 12.0),
        PrimaryTextField(
          fieldKey: Application.numberOfBrotherKey,
          controller: Application.numberOfBrother,
          textInput: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          label: "Number of Brothers",
          hintText: "Enter",
          validator: Commons.forcedTextValidator,
          readOnly: widget.viewOnly,
        ),
        PrimaryTextField(
          fieldKey: Application.numberOfSisterKey,
          controller: Application.numberOfSister,
          textInput: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          label: "Number of Sisters",
          hintText: "Enter",
          validator: Commons.forcedTextValidator,
          readOnly: widget.viewOnly,
        ),
        PrimaryTextField(
          fieldKey: Application.birthOrderKey,
          controller: Application.birthOrder,
          textInput: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          label: "Learners Birth Order Among Siblings",
          hintText: "Enter",
          validator: Commons.forcedTextValidator,
          readOnly: widget.viewOnly,
        ),
        const SizedBox(height: 12.0),
        widget.viewOnly
            ? PrimaryTextField(
                controller: TextEditingController(
                    text: application.is4psBeneficiary?.label),
                label: "Is the family a 4Ps beneficiary",
                readOnly: widget.viewOnly,
              )
            : CustomDropdown<SelectionOption>(
                initialValue: application.is4psBeneficiary,
                value: application.is4psBeneficiary,
                label: "Is the family a 4Ps beneficiary",
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
                onChanged: application.updateIs4psBeneficiary,
                validator: Commons.forcedDropdownValidator,
              ),
        Visibility(
          visible: application.is4psBeneficiary?.id == 0,
          child: PrimaryTextField(
            fieldKey: Application.whenBeneficiaryKey,
            controller: Application.whenBeneficiary,
            label: "Since When?",
            hintText: "Enter",
            validator: Commons.forcedTextValidator,
            readOnly: widget.viewOnly,
          ),
        ),
        const SizedBox(height: 12.0),
        Text(
          "Information Printed By",
          style: theme.textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        PrimaryTextField(
          fieldKey: Application.firstNamePrintedKey,
          controller: Application.firstNamePrinted,
          hintText: "First name",
          label: "First name",
          inputFormatters: [
            FirstLetterUppercaseTextFormatter(),
          ],
          validator: Commons.forcedTextValidator,
          readOnly: widget.viewOnly,
          onChanged: (value) {
            if (value.isNotEmpty) {
              Application.firstNamePrinted.value = Application.firstNamePrinted.value.copyWith(
                text: value[0].toUpperCase() + value.substring(1),
              );
            }
          },
        ),
        PrimaryTextField(
          fieldKey: Application.lastNamePrintedKey,
          controller: Application.lastNamePrinted,
          hintText: "Last name",
          label: "Last name",
          validator: Commons.forcedTextValidator,
          inputFormatters: [
            FirstLetterUppercaseTextFormatter(),
          ],
          readOnly: widget.viewOnly,
          onChanged: (value) {
            if (value.isNotEmpty) {
              Application.lastNamePrinted.value = Application.lastNamePrinted.value.copyWith(
                text: value[0].toUpperCase() + value.substring(1),
              );
            }
          },
        ),
        PrimaryTextField(
          fieldKey: Application.middleNamePrintedKey,
          controller: Application.middleNamePrinted,
          hintText: "Middle name",
          label: "Middle name",
          validator: Commons.forcedTextValidator,
          inputFormatters: [
            FirstLetterUppercaseTextFormatter(),
          ],
          readOnly: widget.viewOnly,
          onChanged: (value) {
            if (value.isNotEmpty) {
              Application.middleNamePrinted.value = Application.middleNamePrinted.value.copyWith(
                text: value[0].toUpperCase() + value.substring(1),
              );
            }
          },
        ),
        PrimaryTextField(
          fieldKey: Application.learnerRelationKey,
          controller: Application.learnerRelation,
          hintText: "Enter",
          label: "Relationship to Learner (if not learner)",
          validator: Commons.forcedTextValidator,
          readOnly: widget.viewOnly,
        ),
        PrimaryTextField(
          fieldKey: Application.dateEnteredKey,
          controller: Application.dateEntered,
          hintText: "Enter",
          label: "Date",
          readOnly: true,
          onTap: () => widget.viewOnly ? null : application.updateDateEntered(context),
        ),
      ],
    );
  }
}
