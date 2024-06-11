import 'package:flutter/material.dart';

class MyPetModal extends StatefulWidget {
  MyPetModal({
    super.key,
    required this.screen,
    required this.itemPath,
    required this.content,
    required this.title,
    this.backgroud,
  });

  final Size screen;
  final String itemPath;
  final Widget content;
  final Widget? backgroud;
  final String? title;

  @override
  State<MyPetModal> createState() => _MyPetModalState();
}

class _MyPetModalState extends State<MyPetModal> {
  bool? waiting = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: widget.screen.height * 0.6,
        maxWidth: widget.screen.width * 0.8,
      ),
      child: Stack(children: [
        widget.backgroud ?? SizedBox.shrink(),
        Column(
          children: [
            Container(
              height: 50,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xfff08636), // FIXME: 색 변경 테스트
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                widget.title ?? '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: SizedBox(
                width: widget.screen.width * 0.5,
                child: Image.asset(
                  'assets/pets/${widget.itemPath.split('.')[0]}.gif',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 20,
                bottom: 10,
                left: 10,
                right: 10,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: widget.content,
            ),
          ],
        ),
      ]),
    );
  }
}
