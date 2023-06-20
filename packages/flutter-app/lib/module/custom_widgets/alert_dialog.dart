import 'package:flutter/material.dart';

void alertDialogs(BuildContext context, String titleText, String contentText,
    VoidCallback onPressed,
    {bool isLoading = false}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              titleText,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ),
          content: SelectableText(
            contentText,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black54),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: TextButton(
                  onPressed: onPressed,
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: Colors.blueGrey),
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Continue',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        )),
            ),
          ]);
    },
  );
}
