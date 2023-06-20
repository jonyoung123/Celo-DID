import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class CustomDropDownWidget extends StatelessWidget {
  const CustomDropDownWidget({
    required this.value,
    required this.items,
    this.text,
    this.onChanged,
    this.subText = 'Select the identifier for generating celo identity',
    this.hint = '',
    Key? key,
  }) : super(key: key);

  final dynamic value;
  final List<DropdownMenuItem<dynamic>>? items;
  final ValueChanged<dynamic>? onChanged;
  final String hint;
  final String? text;
  final String? subText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '$text',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subText!,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            )
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1, color: Colors.black12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButton2(
            underline: DropdownButtonHideUnderline(child: Container()),
            style: const TextStyle(
                fontSize: 15, color: Colors.black, fontWeight: FontWeight.w400),
            items: items,
            hint: Text(
              hint,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54),
            ),
            value: value,
            onChanged: onChanged,
            buttonStyleData: const ButtonStyleData(
              width: double.infinity,
              height: 50,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            ),
            menuItemStyleData:
                const MenuItemStyleData(padding: EdgeInsets.only(left: 20)),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}

class DropDownCustom extends StatelessWidget {
  const DropDownCustom(
      {required this.items,
      this.text,
      required this.onChanged,
      this.value,
      this.subText = 'Select the identifier for generating celo identity',
      this.hint = '',
      super.key});
  final List<String> items;
  final dynamic value;
  final String hint;
  final String? text;
  final String? subText;
  final ValueChanged<dynamic> onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomDropDownWidget(
        value: value,
        hint: hint,
        subText: subText,
        items: items
            .map<DropdownMenuItem<String>>((String item) => DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                )))
            .toList(),
        onChanged: onChanged,
        text: text);
  }
}
