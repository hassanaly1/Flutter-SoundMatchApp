import 'dart:math';

class MyAssetHelper {
  static String onboardingOne = "assets/images/onboarding1.png";
  static String onboardingTwo = "assets/images/onboarding2.png";
  static String onboardingThree = "assets/images/onboarding3.png";
  static String onboardingFour = "assets/images/onboarding4.png";
  static String thinkLoader = "assets/images/think_loader.json";
  static String roundAnimation = "assets/images/round_animation.json";
  static String robot = "assets/svgs/robot.svg";
  static String loader = "assets/svgs/loader.svg";
  static String loaderBackground = "assets/images/loader_background.png";
  static String addParticipants = "assets/svgs/add_participants.svg";

  static String addChallengeBackground = 'assets/images/add_challenge_bg.png';
  static String challengeContainer = 'assets/images/challenge_container.png';
  static String startNow = 'assets/images/start-now.png';
  static String historyRank1 = "assets/images/rank1.png";
  static String backgroundImage = "assets/svgs/backgroundImage.svg";
  static String leaderBackground = "assets/images/leader_background.png";
  static String soundPackBackground = 'assets/svgs/sound_pack_bg.svg';
  static String mic = "assets/images/mic.png";
  static String userBackground = "assets/images/user_background.png";
  static String share = "assets/images/share.png";
  static String personPlaceholder = "assets/images/person_placeholder.png";
  static String person = "assets/images/person.png";
  static String musicIcon = "assets/images/music_icon.png";
  static String musicLoading = "assets/images/music_loading.json";
  static String loading = "assets/images/loading-screen.json";
  static String certified = "assets/images/certified.png";
  static String rank = "assets/images/rank.png";
  static String soundPlus = "assets/images/sound_plus.png";
  static String ranksBackground = "assets/images/ranks_background.png";
  static String pcRank = "assets/images/pc_rank.png";
  static String rankLeft = "assets/images/rank_left.png";
  static String rankRight = "assets/images/rank_right.png";
  static String rankContainerBackground =
      "assets/images/rank_container_background.png";
  static String requestBackground = "assets/images/request_background.png";
  static String lead =
      "https://img.freepik.com/free-photo/expressive-bearded-man-wearing-shirt_273609-5894.jpg?size=626&ext=jpg&ga=GA1.1.2116175301.1701475200&semt=ais";

  static const List<String> dummyImages = [
    "https://img.freepik.com/free-photo/handsome-bearded-businessman-rubbing-hands-having-deal_176420-18778.jpg?size=626&ext=jpg&ga=GA1.1.28285361.1704840180&semt=sph",
    "https://img.freepik.com/free-photo/portrait-young-businesswoman-holding-eyeglasses-hand-against-gray-backdrop_23-2148029483.jpg?size=626&ext=jpg&ga=GA1.1.28285361.1704840180&semt=sph",
    "https://img.freepik.com/free-photo/young-bearded-man-with-striped-shirt_273609-5677.jpg?w=1060&t=st=1704840246~exp=1704840846~hmac=60c212aaf027fe4534abb58865903775fddd738f3a245633ae2dfcabedf23665",
    "https://img.freepik.com/free-photo/bohemian-man-with-his-arms-crossed_1368-3542.jpg?size=626&ext=jpg&ga=GA1.1.28285361.1704840180&semt=sph",
    "https://img.freepik.com/free-photo/handsome-bearded-guy-posing-against-white-wall_273609-20597.jpg?size=626&ext=jpg&ga=GA1.1.28285361.1704840180&semt=sph"
  ];
  static String getDummyImage() {
    return dummyImages[Random().nextInt(dummyImages.length)];
  }
}
