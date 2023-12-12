import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_school/models/application/application.dart';
import 'package:web_school/networks/admin.dart';
import 'package:web_school/views/widgets/forms/emergency.dart';
import 'package:web_school/views/widgets/forms/family.dart';
import 'package:web_school/views/widgets/forms/personal.dart';
import 'package:web_school/views/widgets/forms/residence.dart';
import 'package:web_school/views/widgets/forms/school.dart';

class StudentDetails extends StatelessWidget {
  const StudentDetails({
    required this.applicationInfo,
    super.key,
  });

  final ApplicationInfo applicationInfo;

  @override
  Widget build(BuildContext context) {
    final AdminDB adminDB = Provider.of<AdminDB>(context);
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
          border: Border.all(
        color: Colors.black,
      )),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // InkWell(
                //   // onTap: () => adminDB.updateSchoolInfoShow(),
                //   child: Icon(
                //     adminDB.schoolInfoShow
                //         ? Icons.arrow_drop_up
                //         : Icons.arrow_drop_down,
                //   ),
                // ),
                Text(
                  "School Info",
                  style: theme.textTheme.titleSmall,
                ),
              ],
            ),
            const Divider(
              color: Colors.black,
            ),
            Visibility(
              visible: adminDB.schoolInfoShow,
              child: SchoolInfoForm(
                schoolInfo: applicationInfo.schoolInfo,
                viewOnly: true,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Row(
              children: [
                // InkWell(
                //   // onTap: () => adminDB.updatePersonalInfoShow(),
                //   child: Icon(
                //     adminDB.personalInfoShow
                //         ? Icons.arrow_drop_up
                //         : Icons.arrow_drop_down,
                //   ),
                // ),
                Text(
                  "Personal Info",
                  style: theme.textTheme.titleSmall,
                ),
              ],
            ),
            const Divider(
              color: Colors.black,
            ),
            Visibility(
              visible: adminDB.personalInfoShow,
              child: BasicPersonalInfoForm(
                personalInfo: applicationInfo.personalInfo,
                viewOnly: true,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Row(
              children: [
                // InkWell(
                //   // onTap: () => adminDB.updateResidenceInfoShow(),
                //   child: Icon(
                //     adminDB.residenceInfoShow
                //         ? Icons.arrow_drop_up
                //         : Icons.arrow_drop_down,
                //   ),
                // ),
                Text(
                  "Residence Info",
                  style: theme.textTheme.titleSmall,
                ),
              ],
            ),
            const Divider(
              color: Colors.black,
            ),
            Visibility(
              visible: adminDB.residenceInfoShow,
              child: ResidenceForm(
                residenceInfo: applicationInfo.residenceInfo,
                viewOnly: true,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Row(
              children: [
                // InkWell(
                //   // onTap: () => adminDB.updateEmergencyInfoShow(),
                //   child: Icon(
                //     adminDB.emergencyInfoShow
                //         ? Icons.arrow_drop_up
                //         : Icons.arrow_drop_down,
                //   ),
                // ),
                Text(
                  "Emergency Info",
                  style: theme.textTheme.titleSmall,
                ),
              ],
            ),
            const Divider(
              color: Colors.black,
            ),
            Visibility(
              visible: adminDB.emergencyInfoShow,
              child: EmergencyForm(
                emergencyInfo: applicationInfo.emergencyInfo,
                viewOnly: true,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Row(
              children: [
                // InkWell(
                //   // onTap: () => adminDB.updateFamilyInfoShow(),
                //   child: Icon(
                //     adminDB.familyInfoShow
                //         ? Icons.arrow_drop_up
                //         : Icons.arrow_drop_down,
                //   ),
                // ),
                Text(
                  "Family Info",
                  style: theme.textTheme.titleSmall,
                ),
              ],
            ),
            const Divider(
              color: Colors.black,
            ),
            Visibility(
              visible: adminDB.familyInfoShow,
              child: FamilyInformationForm(
                familyInfo: applicationInfo.familyInfo,
                viewOnly: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
