class ApiEndPoints {
  static String baseUrl = 'https://sounds-match-api-production.up.railway.app/';

  //Authentications
  static String registerUserUrl = 'api/user/register';
  static String loginUserUrl = 'api/user/login';
  static String verifyEmailUrl = 'api/user/verify-email';
  static String sendOtpUrl = 'api/user/send-reset-password-email';
  static String verifyOtpUrl = 'api/user/verify-reset-otp';
  static String changePasswordUrl = 'api/user/changepassword';

  static String listofsoundpacksUrl = 'api/soundpack/getlistofsoundpackages';
  static String listofsoundsByIdUrl = 'api/soundpack/getSoundPackageById';

  //Default Match
  static String defaultMatchUrl = 'api/testmatch/show-test-match-result';

  static String connectToDefaultMatch = 'enter_to_test_room';
}
