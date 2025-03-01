import 'package:flutter/material.dart';

class MethodPayWidget extends StatefulWidget {
  MethodPayWidget(
      {super.key, required this.urlImage, required this.textMethod});

  String urlImage;
  String textMethod;

  @override
  State<MethodPayWidget> createState() => _MethodPayWidgetState();
}

class _MethodPayWidgetState extends State<MethodPayWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset(
                widget.urlImage,
                fit: BoxFit.cover,
                width: 60,
                height: 60,
              ),
              SizedBox(
                width: 10,
              ),
              Text(widget.textMethod),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Divider(
            thickness: 1,
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}
