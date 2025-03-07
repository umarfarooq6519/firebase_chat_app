import 'package:flutter/material.dart';

class CustomAvatar extends StatelessWidget {
  final String? avatarUrl;
  const CustomAvatar({super.key, this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 22,
      backgroundImage: NetworkImage(avatarUrl ??
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTOtdpUeqbe1XGxQ1picj-7UBTis2xV22fWEw&s"),
    );
  }
}
