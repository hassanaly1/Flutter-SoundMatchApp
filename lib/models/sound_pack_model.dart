import 'package:sound_app/models/songs_model.dart';

class SoundPackModel {
  final String packName;
  final String packImage;
  final List<SongsModel> songs;
  final bool isPaid;

  SoundPackModel({
    required this.packName,
    required this.songs,
    required this.packImage,
    required this.isPaid,
  });
}

List<SoundPackModel> soundPacks = [
  SoundPackModel(
    packName: 'Imagine Pack',
    packImage:
        'https://img.freepik.com/free-photo/caucasian-woman-s-portrait-isolated-blue-background-multicolored-neon-light_155003-32526.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
    isPaid: false,
    songs: [
      SongsModel(
        songName: 'Imagine 1',
        songImage:
            'https://img.freepik.com/free-photo/caucasian-woman-s-portrait-isolated-blue-background-multicolored-neon-light_155003-32526.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Imagine 2',
        songImage:
            'https://img.freepik.com/free-photo/caucasian-woman-s-portrait-isolated-blue-background-multicolored-neon-light_155003-32526.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Imagine 3',
        songImage:
            'https://img.freepik.com/free-photo/caucasian-woman-s-portrait-isolated-blue-background-multicolored-neon-light_155003-32526.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Imagine 4',
        songImage:
            'https://img.freepik.com/free-photo/caucasian-woman-s-portrait-isolated-blue-background-multicolored-neon-light_155003-32526.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Imagine 5',
        songImage:
            'https://img.freepik.com/free-photo/caucasian-woman-s-portrait-isolated-blue-background-multicolored-neon-light_155003-32526.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Imagine 6',
        songImage:
            'https://img.freepik.com/free-photo/caucasian-woman-s-portrait-isolated-blue-background-multicolored-neon-light_155003-32526.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Imagine 7',
        songImage:
            'https://img.freepik.com/free-photo/caucasian-woman-s-portrait-isolated-blue-background-multicolored-neon-light_155003-32526.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Imagine 8',
        songImage:
            'https://img.freepik.com/free-photo/caucasian-woman-s-portrait-isolated-blue-background-multicolored-neon-light_155003-32526.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Imagine 9',
        songImage:
            'https://img.freepik.com/free-photo/caucasian-woman-s-portrait-isolated-blue-background-multicolored-neon-light_155003-32526.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Imagine 10',
        songImage:
            'https://img.freepik.com/free-photo/caucasian-woman-s-portrait-isolated-blue-background-multicolored-neon-light_155003-32526.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
    ],
  ),
  SoundPackModel(
    packName: 'Bohemian Rhapsody Pack',
    packImage:
        'https://img.freepik.com/free-photo/one-young-woman-singing-sensually-stage-generated-by-ai_188544-25352.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
    isPaid: false,
    songs: [
      SongsModel(
        songName: 'Bohemian Rhapsody 1',
        songImage:
            'https://img.freepik.com/free-photo/one-young-woman-singing-sensually-stage-generated-by-ai_188544-25352.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Bohemian Rhapsody 2',
        songImage:
            'https://img.freepik.com/free-photo/one-young-woman-singing-sensually-stage-generated-by-ai_188544-25352.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Bohemian Rhapsody 3',
        songImage:
            'https://img.freepik.com/free-photo/one-young-woman-singing-sensually-stage-generated-by-ai_188544-25352.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Bohemian Rhapsody 4',
        songImage:
            'https://img.freepik.com/free-photo/one-young-woman-singing-sensually-stage-generated-by-ai_188544-25352.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Bohemian Rhapsody 5',
        songImage:
            'https://img.freepik.com/free-photo/one-young-woman-singing-sensually-stage-generated-by-ai_188544-25352.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Bohemian Rhapsody 6',
        songImage:
            'https://img.freepik.com/free-photo/one-young-woman-singing-sensually-stage-generated-by-ai_188544-25352.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Bohemian Rhapsody 7',
        songImage:
            'https://img.freepik.com/free-photo/one-young-woman-singing-sensually-stage-generated-by-ai_188544-25352.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Bohemian Rhapsody 8',
        songImage:
            'https://img.freepik.com/free-photo/one-young-woman-singing-sensually-stage-generated-by-ai_188544-25352.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Bohemian Rhapsody 9',
        songImage:
            'https://img.freepik.com/free-photo/one-young-woman-singing-sensually-stage-generated-by-ai_188544-25352.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Bohemian Rhapsody 10',
        songImage:
            'https://img.freepik.com/free-photo/one-young-woman-singing-sensually-stage-generated-by-ai_188544-25352.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
    ],
  ),
  SoundPackModel(
    packName: 'Hotel California Pack',
    packImage:
        'https://img.freepik.com/free-psd/neon-poster-template-electronic-music-with-female-dj_23-2148979680.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
    isPaid: true,
    songs: [
      SongsModel(
        songName: 'Hotel California 1',
        songImage:
            'https://img.freepik.com/free-psd/neon-poster-template-electronic-music-with-female-dj_23-2148979680.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Hotel California 2',
        songImage:
            'https://img.freepik.com/free-psd/neon-poster-template-electronic-music-with-female-dj_23-2148979680.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Hotel California 3',
        songImage:
            'https://img.freepik.com/free-psd/neon-poster-template-electronic-music-with-female-dj_23-2148979680.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Hotel California 4',
        songImage:
            'https://img.freepik.com/free-psd/neon-poster-template-electronic-music-with-female-dj_23-2148979680.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Hotel California 5',
        songImage:
            'https://img.freepik.com/free-psd/neon-poster-template-electronic-music-with-female-dj_23-2148979680.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Hotel California 6',
        songImage:
            'https://img.freepik.com/free-psd/neon-poster-template-electronic-music-with-female-dj_23-2148979680.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Hotel California 7',
        songImage:
            'https://img.freepik.com/free-psd/neon-poster-template-electronic-music-with-female-dj_23-2148979680.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Hotel California 8',
        songImage:
            'https://img.freepik.com/free-psd/neon-poster-template-electronic-music-with-female-dj_23-2148979680.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Hotel California 9',
        songImage:
            'https://img.freepik.com/free-psd/neon-poster-template-electronic-music-with-female-dj_23-2148979680.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Hotel California 10',
        songImage:
            'https://img.freepik.com/free-psd/neon-poster-template-electronic-music-with-female-dj_23-2148979680.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
    ],
  ),
  SoundPackModel(
    packName: 'Yesterday Pack',
    packImage:
        'https://img.freepik.com/free-psd/church-conference-flyer-social-media-post-web-banner-template_505751-3431.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
    isPaid: true,
    songs: [
      SongsModel(
        songName: 'Yesterday 1',
        songImage:
            'https://img.freepik.com/free-psd/church-conference-flyer-social-media-post-web-banner-template_505751-3431.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Yesterday 2',
        songImage:
            'https://img.freepik.com/free-psd/church-conference-flyer-social-media-post-web-banner-template_505751-3431.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Yesterday 3',
        songImage:
            'https://img.freepik.com/free-psd/church-conference-flyer-social-media-post-web-banner-template_505751-3431.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Yesterday 4',
        songImage:
            'https://img.freepik.com/free-psd/church-conference-flyer-social-media-post-web-banner-template_505751-3431.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Yesterday 5',
        songImage:
            'https://img.freepik.com/free-psd/church-conference-flyer-social-media-post-web-banner-template_505751-3431.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Yesterday 6',
        songImage:
            'https://img.freepik.com/free-psd/church-conference-flyer-social-media-post-web-banner-template_505751-3431.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Yesterday 7',
        songImage:
            'https://img.freepik.com/free-psd/church-conference-flyer-social-media-post-web-banner-template_505751-3431.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Yesterday 8',
        songImage:
            'https://img.freepik.com/free-psd/church-conference-flyer-social-media-post-web-banner-template_505751-3431.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Yesterday 9',
        songImage:
            'https://img.freepik.com/free-psd/church-conference-flyer-social-media-post-web-banner-template_505751-3431.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Yesterday 10',
        songImage:
            'https://img.freepik.com/free-psd/church-conference-flyer-social-media-post-web-banner-template_505751-3431.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
    ],
  ),
  SoundPackModel(
    packName: 'Smells Like Teen Spirit Pack',
    packImage:
        'https://img.freepik.com/free-psd/dynamic-fashion-show-social-media-instagram-post-template_47987-16261.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
    isPaid: true,
    songs: [
      SongsModel(
        songName: 'Smells Like Teen Spirit 1',
        songImage:
            'https://img.freepik.com/free-psd/dynamic-fashion-show-social-media-instagram-post-template_47987-16261.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Smells Like Teen Spirit 2',
        songImage:
            'https://img.freepik.com/free-psd/dynamic-fashion-show-social-media-instagram-post-template_47987-16261.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Smells Like Teen Spirit 3',
        songImage:
            'https://img.freepik.com/free-psd/dynamic-fashion-show-social-media-instagram-post-template_47987-16261.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Smells Like Teen Spirit 4',
        songImage:
            'https://img.freepik.com/free-psd/dynamic-fashion-show-social-media-instagram-post-template_47987-16261.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Smells Like Teen Spirit 5',
        songImage:
            'https://img.freepik.com/free-psd/dynamic-fashion-show-social-media-instagram-post-template_47987-16261.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Smells Like Teen Spirit 6',
        songImage:
            'https://img.freepik.com/free-psd/dynamic-fashion-show-social-media-instagram-post-template_47987-16261.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Smells Like Teen Spirit 7',
        songImage:
            'https://img.freepik.com/free-psd/dynamic-fashion-show-social-media-instagram-post-template_47987-16261.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Smells Like Teen Spirit 8',
        songImage:
            'https://img.freepik.com/free-psd/dynamic-fashion-show-social-media-instagram-post-template_47987-16261.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Smells Like Teen Spirit 9',
        songImage:
            'https://img.freepik.com/free-psd/dynamic-fashion-show-social-media-instagram-post-template_47987-16261.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
      SongsModel(
        songName: 'Smells Like Teen Spirit 10',
        songImage:
            'https://img.freepik.com/free-psd/dynamic-fashion-show-social-media-instagram-post-template_47987-16261.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      ),
    ],
  ),
];
