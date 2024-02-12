class SongsModel {
  final String songName;
  final String songImage;

  SongsModel({
    required this.songName,
    required this.songImage,
  });
}

// List<SongsModel> soundsList = [
//   SongsModel(
//     songName: 'Imagine',
//     songImage:
//         'https://img.freepik.com/free-photo/caucasian-woman-s-portrait-isolated-blue-background-multicolored-neon-light_155003-32526.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
//   ),
//   SongsModel(
//     songName: 'Bohemian Rhapsody',
//     songImage:
//         'https://img.freepik.com/free-photo/one-young-woman-singing-sensually-stage-generated-by-ai_188544-25352.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
//   ),
//   SongsModel(
//     songName: 'Hotel California',
//     songImage:
//         'https://img.freepik.com/free-psd/neon-poster-template-electronic-music-with-female-dj_23-2148979680.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
//   ),
//   SongsModel(
//     songName: 'Yesterday',
//     songImage:
//         'https://img.freepik.com/free-psd/church-conference-flyer-social-media-post-web-banner-template_505751-3431.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
//   ),
//   SongsModel(
//     songName: 'Smells Like Teen Spirit',
//     songImage:
//         'https://img.freepik.com/free-psd/dynamic-fashion-show-social-media-instagram-post-template_47987-16261.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
//   ),
//   SongsModel(
//     songName: 'Stairway to Heaven',
//     songImage:
//         'https://img.freepik.com/free-photo/charismatic-modern-young-attractive-africanamerican-girl-with-afro-haircut-listening-music-headph_1258-85160.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
//   ),
//   SongsModel(
//     songName: 'Billie Jean',
//     songImage:
//         'https://img.freepik.com/free-psd/night-party-social-media-template_505751-3465.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
//   ),
//   SongsModel(
//     songName: 'Like a Rolling Stone',
//     songImage:
//         'https://img.freepik.com/free-psd/psd-club-dj-party-flyer-social-media-post-template_505751-3273.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
//   ),
//   SongsModel(
//     songName: 'Purple Haze',
//     songImage:
//         'https://img.freepik.com/free-psd/saturday-party-social-media-template_505751-2942.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
//   ),
//   SongsModel(
//     songName: 'What\'s Going On',
//     songImage:
//         'https://img.freepik.com/free-psd/music-festival-square-flyer-template_23-2149962690.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
//   ),
//   SongsModel(
//     songName: 'Boogie Wonderland',
//     songImage:
//         'https://img.freepik.com/free-psd/virtual-concert-square-flyer_23-2149052650.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
//   ),
//   SongsModel(
//     songName: 'Dancing Queen',
//     songImage:
//         'https://img.freepik.com/free-psd/electro-music-festival-poster-template_23-2148947807.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
//   ),
//   SongsModel(
//     songName: 'Superstition',
//     songImage:
//         'https://img.freepik.com/free-vector/international-jazz-festival-hand-drawn-poster_23-2147782220.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
//   ),
//   SongsModel(
//     songName: 'Another One Bites the Dust',
//     songImage:
//         'https://img.freepik.com/free-psd/blurry-music-festival-poster-template_23-2150045685.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
//   ),
//   SongsModel(
//     songName: 'I Want to Hold Your Hand',
//     songImage:
//         'https://img.freepik.com/free-psd/banner-urban-music-design-template_23-2149081155.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
//   ),
//   SongsModel(
//     songName: 'Let It Be',
//     songImage:
//         'https://img.freepik.com/premium-psd/festival-banner-template_23-2148986204.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
//   ),
//   SongsModel(
//     songName: 'Thriller',
//     songImage:
//         'https://img.freepik.com/premium-psd/club-dj-disco-night-party-social-media-template_516218-218.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
//   ),
//   SongsModel(
//     songName: 'All Along the Watchtower',
//     songImage:
//         'https://img.freepik.com/free-psd/music-show-invitation-template_23-2150058146.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
//   ),
// ];
