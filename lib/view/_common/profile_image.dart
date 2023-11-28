import 'package:flutter/material.dart';
import 'package:iww_frontend/secrets/secrets.dart';

class ProfileImage extends StatelessWidget {
  final double width;
  final double height;
  final int? userId;

  const ProfileImage({
    super.key,
    required this.width,
    required this.height,
    this.userId,
  });

  @override
  Widget build(BuildContext context) {
    // File localProfileImage = LocalStorage.read('$userId.jpg');
    // bool ifLocalFileExist = localProfileImage.exists();

    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),

        child: Image.asset(
          "assets/thumbnail/kitsune.png",
          fit: BoxFit.cover,
        ),
        // child: Image.network(
        //   "${Secrets.REMOTE_SERVER_URL}/image/${userId!}.jpg",
        //   fit: BoxFit.cover,
        //   errorBuilder: (context, error, stackTrace) {
        //     return Image.asset("assets/profile.jpg");
        //   },
        // ),
      ),
    );
  }
}
