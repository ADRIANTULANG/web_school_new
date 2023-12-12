import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:web_school/models/application/application.dart';
import 'package:web_school/models/application/emergency.dart';
import 'package:web_school/models/application/family.dart';
import 'package:web_school/models/application/personal.dart';
import 'package:web_school/models/application/residence.dart';
import 'package:web_school/models/application/school.dart';
import 'package:web_school/models/application/student.dart';
import 'package:web_school/models/option.dart';
import 'package:web_school/models/student/subject.dart';
import 'package:web_school/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:web_school/values/strings/api/twilio.dart';

class Application extends ChangeNotifier {
  bool isLoading = false;

  void showHUD(bool value) {
    isLoading = value;
    notifyListeners();
  }

  // String? formLevel;
  //
  // void updateFormLevel(String? value) {
  //   formLevel = value;
  //   notifyListeners();
  // }

  final List<SelectionOption> schoolYearList = const [
    SelectionOption(id: "0", label: "2023-2024"),
    SelectionOption(id: "1", label: "2024-2025"),
    SelectionOption(id: "2", label: "2025-2026"),
    SelectionOption(id: "3", label: "2026-2027"),
    SelectionOption(id: "4", label: "2027-2028"),
    SelectionOption(id: "5", label: "2028-2029"),
    SelectionOption(id: "6", label: "2029-2030"),
    SelectionOption(id: "7", label: "2030-2031"),
    SelectionOption(id: "8", label: "2031-2032"),
    SelectionOption(id: "9", label: "2032-2033"),
  ];

  SelectionOption? schoolYear;

  void updateSchoolYear(SelectionOption? value) {
    schoolYear = value;
    notifyListeners();
  }

  final List<SelectionOption> juniorGradeList = const [
    SelectionOption(id: "0", label: "Grade 7"),
    SelectionOption(id: "1", label: "Grade 8"),
    SelectionOption(id: "2", label: "Grade 9"),
    SelectionOption(id: "3", label: "Grade 10"),
  ];

  final List<SelectionOption> seniorGradeList = const [
    SelectionOption(id: "0", label: "Grade 11"),
    SelectionOption(id: "1", label: "Grade 12"),
  ];

  SelectionOption? gradeToEnroll;

  void updateGradeToEnroll(SelectionOption? value) {
    gradeToEnroll = value;
    notifyListeners();
  }

  // SelectionOption? assignedLRN;
  //
  // void updateAssignedLRN(SelectionOption? value) {
  //   assignedLRN = value;
  //   notifyListeners();
  // }

  bool newResidency = false;

  void updateNewResidency(bool? value) {
    newResidency = !newResidency;
    notifyListeners();
  }

  static GlobalKey<FormState> formKey = GlobalKey();

  // static TextEditingController gradeToEnroll = TextEditingController();
  // static GlobalKey<FormFieldState> gradeToEnrollKey = GlobalKey();

  final List<SelectionOption> gradeLevelList = const [
    SelectionOption(id: "0", label: "Grade 1"),
    SelectionOption(id: "1", label: "Grade 2"),
    SelectionOption(id: "2", label: "Grade 3"),
    SelectionOption(id: "3", label: "Grade 4"),
    SelectionOption(id: "4", label: "Grade 5"),
    SelectionOption(id: "5", label: "Grade 6"),
    SelectionOption(id: "6", label: "Grade 7"),
  ];

  SelectionOption? lastGradeCompleted;

  void updateLastGradeCompleted(SelectionOption? value) {
    lastGradeCompleted = value;
    notifyListeners();
  }

  // static TextEditingController lastGradeCompleted = TextEditingController();
  // static GlobalKey<FormFieldState> lastGradeCompletedKey = GlobalKey();

  // static TextEditingController lastSchoolYearCompleted = TextEditingController();
  // static GlobalKey<FormFieldState> lastSchoolYearCompletedKey = GlobalKey();

  SelectionOption? lastSchoolYearCompleted;

  void updateLastSchoolYearCompleted(SelectionOption? value) {
    lastSchoolYearCompleted = value;
    notifyListeners();
  }

  final List<SelectionOption> residenceList = const [
    SelectionOption(id: "0", label: "New"),
    SelectionOption(id: "1", label: "Returning"),
  ];

  final List<SelectionOption> otherResidenceList = const [
    SelectionOption(id: "0", label: "New"),
    SelectionOption(id: "1", label: "Continouing"),
  ];

  SelectionOption? residence;

  void updateResidence(SelectionOption? value) {
    residence = value;
    notifyListeners();
  }

  static TextEditingController schoolName = TextEditingController();
  static GlobalKey<FormFieldState> schoolNameKey = GlobalKey();

  static TextEditingController schoolID = TextEditingController();
  static GlobalKey<FormFieldState> schoolIDKey = GlobalKey();

  final List<SelectionOption> schoolTypeList = const [
    SelectionOption(id: "0", label: "Public School"),
    SelectionOption(id: "1", label: "Private School"),
  ];

  SelectionOption? schoolType;

  void updateSchoolType(SelectionOption? value) {
    schoolType = value;
    notifyListeners();
  }

  static TextEditingController schoolAddress = TextEditingController();
  static GlobalKey<FormFieldState> schoolAddressKey = GlobalKey();
  //
  // bool schoolType = false;
  //
  // void updateSchoolType(bool? value) {
  //   schoolType = !schoolType;
  //   notifyListeners();
  // }

  final List<SelectionOption> agreeDisagree = const [
    SelectionOption(id: "0", label: "Yes"),
    SelectionOption(id: "1", label: "No"),
  ];

  SelectionOption? submitCopyPSA;

  void updateSubmitCopyPSA(SelectionOption? value) {
    submitCopyPSA = value;
    notifyListeners();
  }

  // bool submitCopyPSA = false;
  //
  // void updateSubmitCopyPSA(bool? value) {
  //   submitCopyPSA = !submitCopyPSA;
  //   notifyListeners();
  // }
  final List<SelectionOption> otherRequirementsList = const [
    SelectionOption(id: "0", label: "Form 138"),
    SelectionOption(id: "1", label: "Form 137"),
  ];

  SelectionOption? otherRequirements;

  void updateOtherRequirements(SelectionOption? value) {
    otherRequirements = value;
    notifyListeners();
  }

  // bool passForm137 = false;
  //
  // void updatePassForm137(bool? value) {
  //   passForm137 = !passForm137;
  //   notifyListeners();
  // }
  //
  // bool passForm138 = false;
  //
  // void updatePassForm138(bool? value) {
  //   passForm138 = !passForm138;
  //   notifyListeners();
  // }

  final List<SelectionOption> semesterList = const [
    SelectionOption(id: "0", label: "1st Semester"),
    SelectionOption(id: "1", label: "2nd Semester"),
  ];

  SelectionOption? semester;

  void updateSemester(SelectionOption? value) {
    semester = value;
    notifyListeners();
  }

  static TextEditingController track = TextEditingController();
  static GlobalKey<FormFieldState> trackKey = GlobalKey();

  final List<SelectionOption> strandList = const [
    SelectionOption(id: "0", label: "GAS(General Academic Strand)"),
    SelectionOption(
        id: "1", label: "STEM(Science, Technology, Engineering and Mathematics)"),
    SelectionOption(id: "2", label: "HUMMS(Humanities and Social Sciences)"),
  ];

  SelectionOption? strand;

  void updateStrand(SelectionOption? value) {
    strand = value;
    notifyListeners();
  }

  static TextEditingController birthCertNumber = TextEditingController();
  static GlobalKey<FormFieldState> birthCertNumberKey = GlobalKey();

  SelectionOption? hasLRN;

  void updateHasLRN(SelectionOption? value) {
    hasLRN = value;
    notifyListeners();
  }

  static TextEditingController learningReferenceNumber =
      TextEditingController();
  static GlobalKey<FormFieldState> learningReferenceNumberKey = GlobalKey();

  static TextEditingController lastName = TextEditingController();
  static GlobalKey<FormFieldState> lastNameKey = GlobalKey();

  static TextEditingController firstName = TextEditingController();
  static GlobalKey<FormFieldState> firstNameKey = GlobalKey();

  static TextEditingController middleName = TextEditingController();
  static GlobalKey<FormFieldState> middleNameKey = GlobalKey();

  static TextEditingController extensionName = TextEditingController();
  static GlobalKey<FormFieldState> extensionNameKey = GlobalKey();

  static TextEditingController placeOfBirth = TextEditingController();
  static GlobalKey<FormFieldState> placeOfBirthKey = GlobalKey();

  static TextEditingController dateOfBirth = TextEditingController();
  static GlobalKey<FormFieldState> dateOfBirthKey = GlobalKey();

  DateTime? birthDay;

  Future<void> updateBirthDate(BuildContext context) async {
    DateTime? birthDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 50000)),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    // DateFormat format = DateFormat('MM/dd/yyyy');

    if (birthDate != null) {
      DateTime enteredDate = birthDate;
      birthDay = birthDate;
      // DateTime currentDate = DateTime.now();

      dateOfBirth.text = DateFormat("MM/dd/yyyy").format(enteredDate);
      notifyListeners();
    }

    dateOfBirthKey.currentState!.validate();
  }

  static TextEditingController age = TextEditingController();
  static GlobalKey<FormFieldState> ageKey = GlobalKey();

  SelectionOption? gender;

  final List<SelectionOption> genderList = const [
    SelectionOption(id: "0", label: "Male"),
    SelectionOption(id: "1", label: "Female"),
  ];

  void updateGender(SelectionOption? value) {
    gender = value;
    notifyListeners();
  }

  static TextEditingController otherGender = TextEditingController();
  static GlobalKey<FormFieldState> otherGenderKey = GlobalKey();

  SelectionOption? isIndigenousPeople;

  void updateIsIndigenousPeople(SelectionOption? value) {
    isIndigenousPeople = value;
    notifyListeners();
  }

  static TextEditingController indigenousGroup = TextEditingController();
  static GlobalKey<FormFieldState> indigenousGroupKey = GlobalKey();

  static TextEditingController motherTounge = TextEditingController();
  static GlobalKey<FormFieldState> motherToungeKey = GlobalKey();

  static TextEditingController otherLanguages = TextEditingController();
  static GlobalKey<FormFieldState> otherLanguagesKey = GlobalKey();

  SelectionOption? accessComm;

  final List<SelectionOption> accessCommList = const [
    SelectionOption(id: "0", label: "Own Mobile Phone"),
    SelectionOption(id: "1", label: "Parents/relative Mobile Phone"),
  ];

  void updateAccessComm(SelectionOption? value) {
    accessComm = value;
    notifyListeners();
  }

  // SelectionOption? hasPhone;
  //
  // void updateCommunication(SelectionOption? value) {
  //   hasPhone = value!;
  //   notifyListeners();
  // }

  static TextEditingController phoneNumber = TextEditingController();
  static GlobalKey<FormFieldState> phoneNumberKey = GlobalKey();

  static TextEditingController emergencyFirstName = TextEditingController();
  static GlobalKey<FormFieldState> emergencyFirstNameKey = GlobalKey();

  static TextEditingController emergencyMiddleName = TextEditingController();
  static GlobalKey<FormFieldState> emergencyMiddleNameKey = GlobalKey();

  static TextEditingController emergencyLastName = TextEditingController();
  static GlobalKey<FormFieldState> emergencyLastNameKey = GlobalKey();

  static TextEditingController emergencyAddress = TextEditingController();
  static GlobalKey<FormFieldState> emergencyAddressKey = GlobalKey();

  SelectionOption? relationship;

  final List<SelectionOption> relationshipList = const [
    SelectionOption(id: "0", label: "Mother"),
    SelectionOption(id: "1", label: "Father"),
    SelectionOption(id: "1", label: "Daughter"),
    SelectionOption(id: "1", label: "Son"),
    SelectionOption(id: "1", label: "Aunt"),
    SelectionOption(id: "1", label: "Uncle"),
    SelectionOption(id: "1", label: "Cousin"),
    SelectionOption(id: "1", label: "Sister"),
    SelectionOption(id: "1", label: "Brother"),
    SelectionOption(id: "1", label: "Grandmother"),
    SelectionOption(id: "1", label: "Grandfather"),
    SelectionOption(id: "1", label: "Granddaughter"),
    SelectionOption(id: "1", label: "Grandson"),
    SelectionOption(id: "1", label: "Niece"),
    SelectionOption(id: "1", label: "Nephew"),
    SelectionOption(id: "1", label: "Half-Sister"),
    SelectionOption(id: "1", label: "Half-Brother"),
    SelectionOption(id: "1", label: "Step-Mother"),
    SelectionOption(id: "1", label: "Step-Father"),
    SelectionOption(id: "1", label: "Step-Daughter"),
    SelectionOption(id: "1", label: "Step-Son"),
    SelectionOption(id: "1", label: "In-Law"),
  ];

  void updateRelationship(SelectionOption? value) {
    relationship = value;
    notifyListeners();
  }

  static TextEditingController emergencyPhone = TextEditingController();
  static GlobalKey<FormFieldState> emergencyPhoneKey = GlobalKey();

  SelectionOption? currentHousehold;

  final List<SelectionOption> householdList = const [
    SelectionOption(id: "0", label: "Own Family/Sariling Pamilya"),
    SelectionOption(id: "1", label: "Relative/Kamag-anak"),
    SelectionOption(id: "2", label: "Non-relative/Hindi kamag-anak"),
  ];

  void updateCurrentHousehold(SelectionOption? value) {
    currentHousehold = value;
    notifyListeners();
  }

  static TextEditingController address = TextEditingController();
  static GlobalKey<FormFieldState> addressKey = GlobalKey();

  static TextEditingController barangay = TextEditingController();
  static GlobalKey<FormFieldState> barangayKey = GlobalKey();

  static TextEditingController city = TextEditingController();
  static GlobalKey<FormFieldState> cityKey = GlobalKey();

  static TextEditingController province = TextEditingController();
  static GlobalKey<FormFieldState> provinceKey = GlobalKey();

  static TextEditingController region = TextEditingController();
  static GlobalKey<FormFieldState> regionKey = GlobalKey();

  static TextEditingController familyAddress = TextEditingController();
  static GlobalKey<FormFieldState> familyAddressKey = GlobalKey();

  static TextEditingController familyBarangay = TextEditingController();
  static GlobalKey<FormFieldState> familyBarangayKey = GlobalKey();

  static TextEditingController familyCity = TextEditingController();
  static GlobalKey<FormFieldState> familyCityKey = GlobalKey();

  static TextEditingController familyProvince = TextEditingController();
  static GlobalKey<FormFieldState> familyProvinceKey = GlobalKey();

  static TextEditingController familyRegion = TextEditingController();
  static GlobalKey<FormFieldState> familyRegionKey = GlobalKey();

  final List<SelectionOption> responsibleList = const [
    SelectionOption(id: "0", label: "Both Parents / Ama at Ina"),
    SelectionOption(id: "1", label: "Father / Ama"),
    SelectionOption(id: "2", label: "Mother / Ina"),
    SelectionOption(id: "3", label: "Brothers / Kuya"),
    SelectionOption(id: "4", label: "Sisters / Ate"),
    SelectionOption(id: "5", label: "Uncles / Tiyo"),
    SelectionOption(id: "6", label: "Aunts / Tiya"),
    SelectionOption(id: "7", label: "Grandfather / Lolo"),
    SelectionOption(id: "8", label: "Grandmother / Lola"),
    SelectionOption(id: "9", label: "Others"),
  ];

  SelectionOption? responsible;

  void updateResponsible(SelectionOption? value) {
    responsible = value;
    notifyListeners();
  }

  final List<SelectionOption> statusList = const [
    SelectionOption(id: "0", label: "Married & living together"),
    SelectionOption(id: "1", label: "Married but father is working elsewhere"),
    SelectionOption(id: "1", label: "Married but mother is working elsewhere"),
    SelectionOption(id: "2", label: "Separated/Hiwalay"),
    SelectionOption(id: "3", label: "Father is deceased / Pumanaw na ang ama"),
    SelectionOption(id: "3", label: "Mother is deceased / Pumanaw na ang ina"),
    SelectionOption(id: "4", label: "Both parents are deceased"),
    SelectionOption(id: "4", label: "Other / unclear"),
  ];

  SelectionOption? status;

  void updateStatus(SelectionOption? option) {
    status = option;
    notifyListeners();
  }

  static TextEditingController numberOfBrother = TextEditingController();
  static GlobalKey<FormFieldState> numberOfBrotherKey = GlobalKey();

  static TextEditingController numberOfSister = TextEditingController();
  static GlobalKey<FormFieldState> numberOfSisterKey = GlobalKey();

  static TextEditingController birthOrder = TextEditingController();
  static GlobalKey<FormFieldState> birthOrderKey = GlobalKey();

  SelectionOption? is4psBeneficiary;

  void updateIs4psBeneficiary(SelectionOption? option) {
    is4psBeneficiary = option;
    notifyListeners();
  }

  static TextEditingController whenBeneficiary = TextEditingController();
  static GlobalKey<FormFieldState> whenBeneficiaryKey = GlobalKey();

  static TextEditingController lastNamePrinted = TextEditingController();
  static GlobalKey<FormFieldState> lastNamePrintedKey = GlobalKey();

  static TextEditingController firstNamePrinted = TextEditingController();
  static GlobalKey<FormFieldState> firstNamePrintedKey = GlobalKey();

  static TextEditingController middleNamePrinted = TextEditingController();
  static GlobalKey<FormFieldState> middleNamePrintedKey = GlobalKey();

  static TextEditingController learnerRelation = TextEditingController();
  static GlobalKey<FormFieldState> learnerRelationKey = GlobalKey();

  static TextEditingController dateEntered = TextEditingController();
  static GlobalKey<FormFieldState> dateEnteredKey = GlobalKey();

  Future<void> updateDateEntered(BuildContext context) async {
    DateTime? birthDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 50000)),
      lastDate: DateTime.now(),
    );

    // DateFormat format = DateFormat('MM/dd/yyyy');

    if (birthDate != null) {
      DateTime enteredDate = birthDate;
      // DateTime currentDate = DateTime.now();

      dateEntered.text = DateFormat("MM/dd/yyyy").format(enteredDate);
      notifyListeners();
    }

    dateOfBirthKey.currentState!.validate();
  }

  final FirebaseFirestore db = FirebaseFirestore.instance;

  SchoolInfo get getSchoolInfo {
    final SchoolInfo schoolInfo = SchoolInfo(
      schoolYear: schoolYear!,
      gradeToEnroll: gradeToEnroll!,
      lastGradeCompleted: lastGradeCompleted!,
      lastSchoolYear: lastSchoolYearCompleted!,
      residency: residence!,
      nameOfSchool: schoolName.text,
      schoolId: schoolID.text,
      schoolAddress: schoolAddress.text,
      schoolType: schoolType!,
      isPSASubmitted: submitCopyPSA!,
      birthCertificate: birthCertNumber.text,
      otherRequirements: otherRequirements!,
      semester: SelectionOption(
        id: semester == null ? null : semester!.id,
        label: semester == null ? null : semester!.label,
      ),
      track: track.text,
      strand: SelectionOption(
        id: strand == null ? null : strand!.id,
        label: strand == null ? null : strand!.label,
      ),
    );

    return schoolInfo;
  }

  PersonalInfo get getPersonalInfo {
    final PersonalInfo personalInfo = PersonalInfo(
      hasLrn: hasLRN!,
      lrn: learningReferenceNumber.text,
      lastName: lastName.text,
      firstName: firstName.text,
      middleName: middleName.text,
      extensionName:
          extensionName.text.toLowerCase() == "none" ? "" : extensionName.text,
      placeOfBirth: placeOfBirth.text,
      dateOfBirth: dateOfBirth.text,
      age: age.text,
      gender: gender!,
      isIndigenous: isIndigenousPeople,
      motherTounge: motherTounge.text,
      otherLanguage: otherLanguages.text,
    );

    return personalInfo;
  }

  EmergencyInfo get getEmergencyInfo {
    final EmergencyInfo emergencyInfo = EmergencyInfo(
      communication: accessComm!,
      number: phoneNumber.text,
      firstName: emergencyFirstName.text,
      middleName: emergencyMiddleName.text,
      lastName: emergencyLastName.text,
      emergencyAddress: emergencyAddress.text,
      relationship: relationship!,
      address: emergencyAddress.text,
      contactNumber: emergencyPhone.text,
    );

    return emergencyInfo;
  }

  ResidenceInfo get getResidenceInfo {
    final ResidenceInfo residenceInfo = ResidenceInfo(
      household: currentHousehold!,
      currentAddress: Address(
        address: address.text,
        barangay: barangay.text,
        city: city.text,
        province: province.text,
        region: region.text,
      ),
      familyAddress: Address(
        address: familyAddress.text,
        barangay: familyBarangay.text,
        city: familyCity.text,
        province: familyProvince.text,
        region: familyRegion.text,
      ),
      familyInfo: responsible!,
    );

    return residenceInfo;
  }

  FamilyInfo get getFamilyInfo {
    final FamilyInfo familyInfo = FamilyInfo(
      responsible: responsible!,
      parentStatus: status!,
      numberOfBrother: numberOfBrother.text,
      numberOfSister: numberOfSister.text,
      birthNumber: numberOfSister.text,
      beneficiary: is4psBeneficiary!,
      whenBeneficiary: whenBeneficiary.text,
      firstName: firstNamePrinted.text,
      middleName: middleNamePrinted.text,
      lastName: lastNamePrinted.text,
      relationship: learnerRelation.text,
      dateEntered: dateEntered.text,
    );

    return familyInfo;
  }

  String getRandomLetter() {
    Random random = Random();
    int randomAscii =
        random.nextInt(26) + 65; // ASCII code for capital letters (A-Z)
    String randomLetter = String.fromCharCode(randomAscii);
    return randomLetter;
  }

  int getRandomNumber() {
    Random random = Random();
    int randomNumber =
        random.nextInt(100); // Generate a random number between 0 and 99
    return randomNumber;
  }

  String generateRandomPassword() {
    Random random = Random();
    const String numericChars = '0123456789';
    String password = '';

    for (int i = 0; i < 6; i++) {
      int randomIndex = random.nextInt(numericChars.length);
      password += numericChars[randomIndex];
    }

    return password;
  }

  Subject getSubjectData(subject) => Subject(
        id: subject.id,
        name: subject.name,
        grades: subject.grades,
        units: subject.units,
        schedule: [],
      );

  Future<void> submitApplicationForm(
    BuildContext context, {
    bool isJunior = false,
    bool isSenior = false,
    bool isTransferee = false,
  }) async {
    final ThemeData theme = Theme.of(context);
    showHUD(true);

    try {
      final String uid = Uuid().v1();

      final birth = DateFormat("MMyyyy").format(birthDay!).trim();

      final String controlNumber =
          "${getRandomLetter()}${getRandomNumber()}$birth";

      final String password = generateRandomPassword();

      final UserModel userModel = UserModel(
        id: uid,
        controlNumber: controlNumber,
        password: password,
        type: "student",
      );

      final DateTime now = DateTime.now();

      final StudentInfo studentInfo = StudentInfo(
        name:
            "${firstName.text} ${middleName.text} ${lastName.text} ${extensionName.text.toLowerCase() == "none" ? "" : extensionName.text}",
        section: "",
        enrolled: false,
        isTransferee: isTransferee,
        // balance: 1300.0,
      );

      final ApplicationInfo applicationInfo = ApplicationInfo(
        userModel: userModel,
        studentInfo: studentInfo,
        schoolInfo: getSchoolInfo,
        personalInfo: getPersonalInfo,
        emergencyInfo: getEmergencyInfo,
        residenceInfo: getResidenceInfo,
        familyInfo: getFamilyInfo,
        createdAt: Timestamp.fromDate(now),
      );

      db.collection("user").doc(uid).set(userModel.toJson());

      db
          .collection("student")
          .doc(uid)
          .set(applicationInfo.toJson())
          .then((value) async {
        sendSMS(
          controlNumber: controlNumber,
          password: password,
        );

        final CollectionReference subjectsCollection =
            db.collection("student").doc(uid).collection("subjects");

        if (isJunior) {
          //################# JUNIOR SUBJECT ########################333
          var resjuniorSubject = await FirebaseFirestore.instance
              .collection('juniorSubject')
              .get();
          var jsubject = resjuniorSubject.docs;
          List<Subject> juniorSubjects = <Subject>[];
          for (var i = 0; i < jsubject.length; i++) {
            List<Grade> gradesList = <Grade>[];
            for (var x = 0; x < jsubject[i]['grades'].length; x++) {
              gradesList.add(Grade(
                  title: jsubject[i]['grades'][x]['title'],
                  grade: double.parse(
                      jsubject[i]['grades'][x]['grade'].toString())));
            }
            juniorSubjects.add(Subject(
                name: jsubject[i]['name'],
                grades: gradesList,
                units: jsubject[i]['units'],
                id: jsubject[i]['id']));
          }
          //#########################################333
          for (Subject subject in juniorSubjects) {
            subjectsCollection.doc(subject.id.toString()).set(subject.toJson());
          }
        } else if (isSenior) {
          // For stem
          if (strand?.id == 1) {
            if (semester?.id == 0) {
              //##################### STEM FIRST SUBJECT ###########################
              var stemFirstSubjectList = await FirebaseFirestore.instance
                  .collection('stemFirstSubjectList')
                  .get();
              var subject = stemFirstSubjectList.docs;
              List<Subject> stemFirstSubjects = <Subject>[];
              for (var i = 0; i < subject.length; i++) {
                List<Grade> gradesList = <Grade>[];
                for (var x = 0; x < subject[i]['grades'].length; x++) {
                  gradesList.add(Grade(
                      title: subject[i]['grades'][x]['title'],
                      grade: double.parse(
                          subject[i]['grades'][x]['grade'].toString())));
                }
                stemFirstSubjects.add(Subject(
                    name: subject[i]['name'],
                    grades: gradesList,
                    units: subject[i]['units'],
                    id: subject[i]['id']));
              }
              //###############################################
              for (Subject subject in stemFirstSubjects) {
                subjectsCollection
                    .doc(subject.id.toString())
                    .set(getSubjectData(subject).toJson());
              }
            } else {
              //###################### STEM SECOND SUBJECT ##########################
              var stemSecondSubjectList = await FirebaseFirestore.instance
                  .collection('stemSecondSubjectList')
                  .get();
              var subject = stemSecondSubjectList.docs;
              List<Subject> stemSecondSubject = <Subject>[];
              for (var i = 0; i < subject.length; i++) {
                List<Grade> gradesList = <Grade>[];
                for (var x = 0; x < subject[i]['grades'].length; x++) {
                  gradesList.add(Grade(
                      title: subject[i]['grades'][x]['title'],
                      grade: double.parse(
                          subject[i]['grades'][x]['grade'].toString())));
                }
                stemSecondSubject.add(Subject(
                    name: subject[i]['name'],
                    grades: gradesList,
                    units: subject[i]['units'],
                    id: subject[i]['id']));
              }
              //###############################################
              for (Subject subject in stemSecondSubject) {
                subjectsCollection
                    .doc(subject.id.toString())
                    .set(getSubjectData(subject).toJson());
              }
            }
          }
          // For gas
          else if (strand?.id == 0) {
            if (semester?.id == 0) {
              //###################### GAS FIRST SUBJECT ##########################
              var gasFirstSubjectList = await FirebaseFirestore.instance
                  .collection('gasFirstSubjectList')
                  .get();
              var subject = gasFirstSubjectList.docs;
              List<Subject> gasFirstSubject = <Subject>[];
              for (var i = 0; i < subject.length; i++) {
                List<Grade> gradesList = <Grade>[];
                for (var x = 0; x < subject[i]['grades'].length; x++) {
                  gradesList.add(Grade(
                      title: subject[i]['grades'][x]['title'],
                      grade: double.parse(
                          subject[i]['grades'][x]['grade'].toString())));
                }
                gasFirstSubject.add(Subject(
                    name: subject[i]['name'],
                    grades: gradesList,
                    units: subject[i]['units'],
                    id: subject[i]['id']));
              }
              //###############################################
              for (Subject subject in gasFirstSubject) {
                subjectsCollection
                    .doc(subject.id.toString())
                    .set(getSubjectData(subject).toJson());
              }
            } else {
              //###################### GAS SECOND SUBJECT ##########################
              var gasSecondSubjectList = await FirebaseFirestore.instance
                  .collection('gasSecondSubjectList')
                  .get();
              var subject = gasSecondSubjectList.docs;
              List<Subject> gasSecondSubject = <Subject>[];
              for (var i = 0; i < subject.length; i++) {
                List<Grade> gradesList = <Grade>[];
                for (var x = 0; x < subject[i]['grades'].length; x++) {
                  gradesList.add(Grade(
                      title: subject[i]['grades'][x]['title'],
                      grade: double.parse(
                          subject[i]['grades'][x]['grade'].toString())));
                }
                gasSecondSubject.add(Subject(
                    name: subject[i]['name'],
                    grades: gradesList,
                    units: subject[i]['units'],
                    id: subject[i]['id']));
              }
              //###############################################
              for (Subject subject in gasSecondSubject) {
                subjectsCollection
                    .doc(subject.id.toString())
                    .set(getSubjectData(subject).toJson());
              }
            }
          }
          // For humms
          else if (strand?.id == 2) {
            if (semester?.id == 0) {
              //###################### HUM FIRST SUBJECT ##########################
              var hummsFirstSubjectList = await FirebaseFirestore.instance
                  .collection('hummsFirstSubjectList')
                  .get();
              var subject = hummsFirstSubjectList.docs;
              List<Subject> hummsFirstSubject = <Subject>[];
              for (var i = 0; i < subject.length; i++) {
                List<Grade> gradesList = <Grade>[];
                for (var x = 0; x < subject[i]['grades'].length; x++) {
                  gradesList.add(Grade(
                      title: subject[i]['grades'][x]['title'],
                      grade: double.parse(
                          subject[i]['grades'][x]['grade'].toString())));
                }
                hummsFirstSubject.add(Subject(
                    name: subject[i]['name'],
                    grades: gradesList,
                    units: subject[i]['units'],
                    id: subject[i]['id']));
              }
              //###############################################
              for (Subject subject in hummsFirstSubject) {
                subjectsCollection
                    .doc(subject.id.toString())
                    .set(getSubjectData(subject).toJson());
              }
            } else {
              //###################### HUM FIRST SUBJECT ##########################
              var hummsSecondSubjectList = await FirebaseFirestore.instance
                  .collection('hummsSecondSubjectList')
                  .get();
              var subject = hummsSecondSubjectList.docs;
              List<Subject> hummsSecondSubject = <Subject>[];
              for (var i = 0; i < subject.length; i++) {
                List<Grade> gradesList = <Grade>[];
                for (var x = 0; x < subject[i]['grades'].length; x++) {
                  gradesList.add(Grade(
                      title: subject[i]['grades'][x]['title'],
                      grade: double.parse(
                          subject[i]['grades'][x]['grade'].toString())));
                }
                hummsSecondSubject.add(Subject(
                    name: subject[i]['name'],
                    grades: gradesList,
                    units: subject[i]['units'],
                    id: subject[i]['id']));
              }
              //###############################################
              for (Subject subject in hummsSecondSubject) {
                subjectsCollection
                    .doc(subject.id.toString())
                    .set(getSubjectData(subject).toJson());
              }
            }
          }
        }
      });

      // clearForm();
      showHUD(false);
    } catch (e) {
      showHUD(false);
      Future.delayed(Duration.zero, () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(
                  "Please enter all valid requirements",
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: Colors.red,
                  ),
                ),
              );
            });
      });

      throw "Error: $e";
    }
  }

  void clearForm() {
    schoolYear = null;
    gradeToEnroll = null;
    lastGradeCompleted = null;
    lastSchoolYearCompleted = null;
    residence = null;
    semester = null;
    track.clear();
    strand = null;

    schoolName.clear();
    schoolID.clear();
    schoolAddress.clear();
    schoolType = null;
    submitCopyPSA = null;
    birthCertNumber.clear();
    otherRequirements = null;

    hasLRN = null;
    learningReferenceNumber.clear();
    lastName.clear();
    firstName.clear();
    middleName.clear();
    extensionName.clear();
    placeOfBirth.clear();
    dateOfBirth.clear();
    age.clear();
    gender = null;
    isIndigenousPeople = null;
    motherTounge.clear();
    otherLanguages.clear();
    accessComm = null;
    phoneNumber.clear();
    emergencyFirstName.clear();
    emergencyMiddleName.clear();
    emergencyLastName.clear();
    relationship = null;
    emergencyAddress.clear();
    emergencyPhone.clear();
    currentHousehold = null;
    address.clear();
    barangay.clear();
    city.clear();
    province.clear();
    region.clear();
    familyAddress.clear();
    familyBarangay.clear();
    familyCity.clear();
    familyRegion.clear();
    responsible = null;
    status = null;
    numberOfBrother.clear();
    numberOfSister.clear();
    birthOrder.clear();
    is4psBeneficiary = null;
    whenBeneficiary.clear();
    lastNamePrinted.clear();
    firstNamePrinted.clear();
    middleNamePrinted.clear();
    learnerRelation.clear();
    dateEntered.clear();
    notifyListeners();
  }

  Future<void> sendSMS({
    required String controlNumber,
    required String password,
  }) async {
    final Uri uri = Uri.https(TwilioApi.BASE_URL, TwilioApi.message);

    await http
        .post(
      uri,
      body: {
        // "to": phoneNumber.text,
        "To": "+639505611018",
        "From": "+12055709584",
        "Body":
            "Your account is: Control number: $controlNumber and Password: $password",
      },
      headers: TwilioApi.headers,
    )
        .then((http.Response response) {
      debugPrint(uri.toString());
      print(TwilioApi.headers);
      debugPrint("Status Code: ${response.statusCode}");
      if (response.statusCode == 201 && response.body.isNotEmpty) {
        debugPrint(response.body);
      } else {
        throw "${response.body}";
      }
    }).timeout(const Duration(seconds: 30), onTimeout: () {
      throw "Time exceeded.";
    }).onError((error, stackTrace) {
      debugPrint("Error: $error");
      debugPrint("Stacktrace: $stackTrace");
    });
  }
}
