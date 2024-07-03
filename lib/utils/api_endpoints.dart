class ApiEndPoints {
  // static String baseUrl = 'https://sounds-match-api-production.up.railway.app/';
  // static String baseUrl = '192.168.100.24/'; //localhost
  static String baseUrl = 'http://10.0.2.2:5000/'; //localhost

  //Authentications
  static String registerUserUrl = 'api/user/register';
  static String loginUserUrl = 'api/user/login';
  static String verifyEmailUrl = 'api/user/verify-email';
  static String sendOtpUrl = 'api/user/send-reset-password-email';
  static String verifyOtpUrl = 'api/user/verify-reset-otp';
  static String changePasswordUrl = 'api/user/changepassword';

  //Sound&SoundPacks
  static String listofsoundpacksUrl = 'api/soundpack/getlistofsoundpackages';
  static String listofsoundsByIdUrl = 'api/soundpack/getSoundPackageById';

  //Participants
  static String listOfParticipantsUrl = 'api/user/get-users-paginated-List';

  //Default Match
  static String defaultMatchUrl = 'show-test-match-result';

  static String connectToDefaultMatch = 'enter_to_test_room';
  static String connectToCreateChallenge = 'create_challenge';
  static String showTestMatchResult = 'show_test_match_result';
  static String connectToRoom = 'connect_to_room';
  static String getInvitations = 'get_invitations';
}

//------------------------------------------------------------------------------
// To test your APIs locally in Flutter while your backend server is running on your PC, you can follow these steps:
//
// Run Your Backend Server:
// Ensure your backend server is up and running on your local machine. Typically, this would be accessible via a URL like http://localhost:3000 or http://127.0.0.1:3000.
//
// Network Configuration:
// For mobile apps running on an emulator or a real device, you need to use the correct IP address to reach your local server.
//
// Android Emulator:
// Use http://10.0.2.2:3000 instead of http://localhost:3000. The 10.0.2.2 IP address is a special alias to your host loopback interface (i.e., localhost).
//
// iOS Simulator:
// Use http://127.0.0.1:3000 or http://localhost:3000. The iOS simulator maps localhost to the host machine.
//
// Real Device:
// You need to use your machine's local network IP address. Find your local IP address (e.g., 192.168.1.100) and use it in your API calls: http://192.168.1.100:3000.

///Testing Locally with localhost
//String baseUrl;
//
// // Example of setting the base URL based on the platform
// if (Platform.isAndroid) {
//   baseUrl = 'http://10.0.2.2:3000';
// } else if (Platform.isIOS) {
//   baseUrl = 'http://127.0.0.1:3000';
// } else {
//   baseUrl = 'http://192.168.1.100:3000'; // Use your local IP address for other platforms
// }
