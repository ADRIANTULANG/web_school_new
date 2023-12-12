import 'package:auto_route/auto_route.dart';
import 'package:web_school/networks/router/routes.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: ResponsiveBuilder.page, initial: true, path: "/"),
        AutoRoute(page: LoginRoute.page, path: "/login"),
        AutoRoute(page: ContinueJuniorRoute.page, path: "/continueJunior"),
        AutoRoute(page: IncomingJuniorFormRoute.page, path: "/incomingJunior"),
        AutoRoute(page: TransfereeJuniorRoute.page, path: "/transfereeJunior"),
        AutoRoute(page: NewSeniorRoute.page, path: "/newSenior"),
        AutoRoute(page: ContinuingSeniorRoute.page, path: "/continueSenior"),
        AutoRoute(page: OtherSchoolRoute.page, path: "/otherSchool"),
        AutoRoute(page: FormsRoute.page, path: "/form"),

        AutoRoute(
          page: AdminHomeRoute.page,
          path: "/adminHome",
        ),
        AutoRoute(
            page: AdminStudentProfileRoute.page, path: "/adminStudentProfile"),

        // AutoRoute(page: StudentLayoutBuilder.page, path: "/studentLayout"),
        AutoRoute(page: StudentHomeRoute.page, path: "/studentHome"),
        AutoRoute(
            page: StudentMobileHomeRoute.page, path: "/studentMobileHome"),
        AutoRoute(
            page: StudentMobileChangePassRoute.page,
            path: "/studentMobileChangePass"),
        AutoRoute(
            page: StudentMobileInfoRoute.page, path: "/studentMobileInfo"),
        AutoRoute(
            page: StudentMobileEnrollmentRoute.page,
            path: "/studentMobileEnrollment"),
        AutoRoute(
            page: StudentMobileScheduleRoute.page,
            path: "/studentMobileSchedule"),

        AutoRoute(
          page: AdminStudentsListRoute.page,
          path: "/adminStudentsListRoute",
        ),
        AutoRoute(
          page: WrapperAdminRoute.page,
          path: "/wrapperAdminRoute",
        ),
        AutoRoute(
          page: WrapperInstructorRoute.page,
          path: "/wrapperInstructorRoute",
        ),
        AutoRoute(
          page: WrapperStudentRoute.page,
          path: "/wrapperStudentRoute",
        ),
        AutoRoute(
            page: AdminInstructorListRoute.page, path: "/adminInstructorHome"),
        AutoRoute(
            page: AdminAddInstructorRoute.page, path: "/adminAddInstructor"),
        AutoRoute(
            page: AdminInstructorSectionRoute.page,
            path: "/adminInstructorSection"),
        AutoRoute(
            page: AdminInstructorGradeRoute.page,
            path: "/adminInstructorGrade"),
        AutoRoute(
            page: AdminInstructorStudentListRoute.page,
            path: "/adminInstructorStudentList"),
        AutoRoute(
            page: AdminEditInstructorRoute.page, path: "/adminEditInstructor"),
        AutoRoute(
            page: AdminScheduleStudentRoute.page,
            path: "/adminScheduleStudent"),

        AutoRoute(page: SummaryPaymentRoute.page, path: "/summaryPayment"),
        AutoRoute(page: PaymentHistoryRoute.page, path: "/paymentHistory"),

        AutoRoute(
            page: InstructorScheduleRoute.page, path: "/instructorSchedule"),
        AutoRoute(
            page: InstructorProfileRoute.page, path: "/instructorProfile"),
        AutoRoute(
            page: InstructorJuniorGradeRoute.page,
            path: "/instructorJuniorGrade"),
        AutoRoute(
            page: InstructorSeniorGradeRoute.page,
            path: "/instructorSeniorGrade"),
        AutoRoute(page: AdviserJuniorGradeView.page, path: "/adviserJunior"),
        AutoRoute(page: AdviserSeniorGradeView.page, path: "/adviserSenior"),
        AutoRoute(page: StrandRoute.page, path: "/Strand"),

        // AutoRoute(page: WebStudentHomeRoute.page, path: "/webStudentHome"),StrandRoute
      ];
}
