import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:web_school/extensions/formatters/first_letter.dart';
import 'package:web_school/models/application/emergency.dart';
import 'package:web_school/models/option.dart';
import 'package:web_school/networks/application.dart';
import 'package:web_school/networks/commons.dart';
import 'package:web_school/views/widgets/buttons/dropdown.dart';
import 'package:web_school/views/widgets/fields/dropdown.dart';
import 'package:web_school/views/widgets/fields/primary.dart';

class EmergencyForm extends StatefulWidget {
  const EmergencyForm({
    this.emergencyInfo,
    this.viewOnly = false,
    super.key,
  });

  final bool viewOnly;
  final EmergencyInfo? emergencyInfo;

  @override
  State<EmergencyForm> createState() => _EmergencyFormState();
}

class _EmergencyFormState extends State<EmergencyForm> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Application application =
          Provider.of<Application>(context, listen: false);

      if (widget.viewOnly) {
        setState(() {
          final EmergencyInfo emergencyInfo = widget.emergencyInfo!;
          application.accessComm = emergencyInfo.communication;
          Application.phoneNumber.text = emergencyInfo.number;
          Application.emergencyFirstName.text = emergencyInfo.firstName;
          Application.emergencyMiddleName.text = emergencyInfo.middleName;
          Application.emergencyLastName.text = emergencyInfo.lastName;
          application.relationship = emergencyInfo.relationship;
          Application.emergencyAddress.text = emergencyInfo.address;
          Application.emergencyPhone.text = emergencyInfo.contactNumber;
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
        const SizedBox(height: 12.0),
        Text(
          "B.2. Communication / Emergency Contact Information",
          style: theme.textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12.0),
        widget.viewOnly
            ? PrimaryTextField(
                controller:
                    TextEditingController(text: application.accessComm?.label),
                label: "Best Communication Access",
                readOnly: widget.viewOnly,
              )
            : CustomDropdown<SelectionOption>(
                initialValue: application.accessComm,
                value: application.accessComm,
                label: "Best Communication Access",
                hintText: 'Select',
                items: application.accessCommList.map((SelectionOption option) {
                  return SchoolDropdownMenuItem<SelectionOption>(
                    value: option,
                    label: option.label!,
                    child: SchoolDropdown(
                      option: option,
                    ),
                  );
                }).toList(),
                onChanged: application.updateAccessComm,
                validator: Commons.forcedDropdownValidator,
              ),
        Visibility(
          visible: application.accessComm != null,
          child: PrimaryTextField(
            fieldKey: Application.phoneNumberKey,
            controller: Application.phoneNumber,
            hintText: "+63XXXXXXXXXX",
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            textInput: TextInputType.phone,
            label: application.accessComm?.id == 0
                ? "Enter your own cellphone number"
                : "Enter the cellphone number of parents/relatives",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "This field is required";
              } else if (value[0] == "0") {
                return "Please start with 63";
              } else {
                return null;
              }
            },
            readOnly: widget.viewOnly,
          ),
        ),
        const SizedBox(height: 12.0),
        Text(
          "Emergency Contact: Information",
          style: theme.textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
          softWrap: true,
        ),
        PrimaryTextField(
          fieldKey: Application.emergencyFirstNameKey,
          controller: Application.emergencyFirstName,
          hintText: "Enter",
          label: "First Name",
          inputFormatters: [
            FirstLetterUppercaseTextFormatter(),
          ],
          readOnly: widget.viewOnly,
          onChanged: (value) {
            if (value.isNotEmpty) {
              Application.emergencyFirstName.value = Application.emergencyFirstName.value.copyWith(
                text: value[0].toUpperCase() + value.substring(1),
              );
            }
          },
        ),
        PrimaryTextField(
          fieldKey: Application.emergencyMiddleNameKey,
          controller: Application.emergencyMiddleName,
          hintText: "Enter",
          label: "Middle Name",
          inputFormatters: [
            FirstLetterUppercaseTextFormatter(),
          ],
          readOnly: widget.viewOnly,
          onChanged: (value) {
            if (value.isNotEmpty) {
              Application.emergencyMiddleName.value = Application.emergencyMiddleName.value.copyWith(
                text: value[0].toUpperCase() + value.substring(1),
              );
            }
          },
        ),
        PrimaryTextField(
          fieldKey: Application.emergencyLastNameKey,
          controller: Application.emergencyLastName,
          hintText: "Enter",
          label: "Last Name",
          inputFormatters: [
            FirstLetterUppercaseTextFormatter(),
          ],
          readOnly: widget.viewOnly,
          onChanged: (value) {
            if (value.isNotEmpty) {
              Application.emergencyLastName.value = Application.emergencyLastName.value.copyWith(
                text: value[0].toUpperCase() + value.substring(1),
              );
            }
          },
        ),
        const SizedBox(height: 12.0),
        widget.viewOnly
            ? PrimaryTextField(
                controller: TextEditingController(
                    text: application.relationship?.label),
                label: "Relationship",
                readOnly: widget.viewOnly,
              )
            : CustomDropdown<SelectionOption>(
                initialValue: application.relationship,
                value: application.relationship,
                label: "Relationship",
                hintText: 'Select',
                items:
                    application.relationshipList.map((SelectionOption option) {
                  return SchoolDropdownMenuItem<SelectionOption>(
                    value: option,
                    label: option.label!,
                    child: SchoolDropdown(
                      option: option,
                    ),
                  );
                }).toList(),
                onChanged: application.updateRelationship,
                validator: Commons.forcedDropdownValidator,
              ),
        PrimaryTextField(
          fieldKey: Application.emergencyAddressKey,
          controller: Application.emergencyAddress,
          hintText: "Enter",
          label: "Address",
          inputFormatters: [
            FirstLetterUppercaseTextFormatter(),
          ],
          readOnly: widget.viewOnly,
          onChanged: (value) {
            if (value.isNotEmpty) {
              Application.emergencyAddress.value = Application.emergencyAddress.value.copyWith(
                text: value[0].toUpperCase() + value.substring(1),
              );
            }
          },
        ),
        PrimaryTextField(
          fieldKey: Application.emergencyPhoneKey,
          controller: Application.emergencyPhone,
          hintText: "Enter",
          label: "Contact Number",
          readOnly: widget.viewOnly,
        ),
      ],
    );
  }
}
