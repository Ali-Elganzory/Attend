import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title, description, positiveButtonText, negativeButtonText;
  final Image image;

  CustomDialog({
    @required this.title,
    @required this.description,
    @required this.positiveButtonText,
    @required this.negativeButtonText,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    double padding = 0.06 * MediaQuery.of(context).size.width;
    double avatarRadius = 0.15 * MediaQuery.of(context).size.width;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: padding,
              bottom: padding,
              left: padding,
              right: padding,
            ),
            margin: EdgeInsets.symmetric(vertical: avatarRadius),
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(9.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
                SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (positiveButtonText != null)
                      Container(
                        height: 35.0,
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pop("positive"); // To close the dialog
                          },
                          child: Text(
                            positiveButtonText,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9.0),
                          ),
                        ),
                      ),
                    if (negativeButtonText != null)
                      Container(
                        height: 35.0,
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pop("negative"); // To close the dialog
                          },
                          child: Text(
                            negativeButtonText,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          color: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.2 * padding),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

showErrorDialog(BuildContext context, String errorMessage) {
  showDialog(
    context: context,
    builder: (ctx) => CustomDialog(
      title: "Something went wrong..",
      description: errorMessage,
      positiveButtonText: null,
      negativeButtonText: "Okay",
    ),
  );
}
