import 'package:flutter/material.dart';
import 'package:notabilia/config/language/locale_controller.dart';
import 'package:notabilia/shared/constants/note_colors.dart';
import 'package:notabilia/shared/constants/sizes.dart';

import '../constants/colors.dart';

class NoteBox extends StatelessWidget {
  final String title;
  final String content;
  final String dateAndTime;
  final int colorIndex;
  final bool? isFavorite;
  final IconData? icon;
  final VoidCallback onTap;
  final VoidCallback? onFavoritePressed;

  const NoteBox({
    super.key,
    required this.title,
    required this.content,
    required this.dateAndTime,
    required this.colorIndex,
    this.isFavorite,
    this.icon,
    required this.onTap,
    this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: kCardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                        fontSize: 20.0,
                        fontFamily: "ibmFont"),
                    overflow: TextOverflow.ellipsis,
                  ),
                  kSizedBoxHeight_10,
                  Text(
                    dateAndTime,
                    style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                        fontSize: 12.0,
                        fontFamily: "ibmFont"),
                    maxLines: 7,
                    overflow: TextOverflow.ellipsis,
                  ),
                  kSizedBoxHeight_5,
                  Text(
                    content,
                    style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                        fontSize: 14.0,
                        fontFamily: "ibmFont"),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 8.0,
              right: LocalController().isEnglish ? null : 20.0,
              left: LocalController().isEnglish ? 20.0 : null,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: NoteColors.colors[colorIndex],
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: 0.0,
              right: LocalController().isEnglish ? 5.0 : null,
              left: LocalController().isEnglish ? null : 5.0,
              child: IconButton(
                onPressed: onFavoritePressed,
                icon: Icon(
                  icon,
                  color: Colors.red.shade800,
                  size: 20.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
