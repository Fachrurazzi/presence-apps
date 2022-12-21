import 'package:get/get.dart';

import 'package:presence_apps/app/modules/add_employee/bindings/add_employee_binding.dart';
import 'package:presence_apps/app/modules/add_employee/views/add_employee_view.dart';
import 'package:presence_apps/app/modules/all_presence/bindings/all_presence_binding.dart';
import 'package:presence_apps/app/modules/all_presence/views/all_presence_view.dart';
import 'package:presence_apps/app/modules/detail_presence/bindings/detail_presence_binding.dart';
import 'package:presence_apps/app/modules/detail_presence/views/detail_presence_view.dart';
import 'package:presence_apps/app/modules/forgot_password/bindings/forgot_password_binding.dart';
import 'package:presence_apps/app/modules/forgot_password/views/forgot_password_view.dart';
import 'package:presence_apps/app/modules/home/bindings/home_binding.dart';
import 'package:presence_apps/app/modules/home/views/home_view.dart';
import 'package:presence_apps/app/modules/login/bindings/login_binding.dart';
import 'package:presence_apps/app/modules/login/views/login_view.dart';
import 'package:presence_apps/app/modules/new_password/bindings/new_password_binding.dart';
import 'package:presence_apps/app/modules/new_password/views/new_password_view.dart';
import 'package:presence_apps/app/modules/profile/bindings/profile_binding.dart';
import 'package:presence_apps/app/modules/profile/views/profile_view.dart';
import 'package:presence_apps/app/modules/update_password/bindings/update_password_binding.dart';
import 'package:presence_apps/app/modules/update_password/views/update_password_view.dart';
import 'package:presence_apps/app/modules/update_profile/bindings/update_profile_binding.dart';
import 'package:presence_apps/app/modules/update_profile/views/update_profile_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.ADD_EMPLOYEE,
      page: () => AddEmployeeView(),
      binding: AddEmployeeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.NEW_PASSWORD,
      page: () => NewPasswordView(),
      binding: NewPasswordBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.UPDATE_PROFILE,
      page: () => UpdateProfileView(),
      binding: UpdateProfileBinding(),
    ),
    GetPage(
      name: _Paths.UPDATE_PASSWORD,
      page: () => UpdatePasswordView(),
      binding: UpdatePasswordBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_PRESENCE,
      page: () => DetailPresenceView(),
      binding: DetailPresenceBinding(),
    ),
    GetPage(
      name: _Paths.ALL_PRESENCE,
      page: () => AllPresenceView(),
      binding: AllPresenceBinding(),
    ),
  ];
}
