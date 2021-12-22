import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final String hint;
  final bool isPasswordField;
  final Function(String? value) onChange;
  final TextInputType keyboardType;
  Widget? prefix;
  Widget? suffix;
  int? limit;
  TextEditingController? controller;
  VoidCallback? onTap;
  bool? readOnly;
  double? elevation;
  Color? shadowColor;

  @override
  _CustomInputFieldState createState() => _CustomInputFieldState();

  CustomInputField({
    required this.hint,
    required this.isPasswordField,
    required this.onChange,
    required this.keyboardType,
    this.prefix,
    this.suffix,
    this.limit,
    this.controller,
    this.onTap,
    this.readOnly,
    this.elevation,
    this.shadowColor,
  });
}

class _CustomInputFieldState extends State<CustomInputField> {
  late bool _isHidden;

  @override
  void initState() {
    _isHidden = widget.isPasswordField;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        maxLength: widget.limit,
        onChanged: widget.onChange,
        obscureText: _isHidden,
        onTap: widget.onTap,
        readOnly: widget.readOnly ?? false,
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        decoration: InputDecoration(
            prefixIcon: widget.prefix,
            suffix: widget.suffix,
            hintText: widget.hint,
            fillColor: Color(0xFFF2F2F2),
            filled: true,
            suffixIcon: widget.isPasswordField
                ? IconButton(
                    onPressed: () {
                      if (widget.isPasswordField) {
                        setState(() {
                          _isHidden = !_isHidden;
                        });
                      }
                    },
                    icon: Visibility(
                      visible: widget.isPasswordField,
                      child: Icon(
                        widget.isPasswordField
                            ? (_isHidden
                                ? Icons.visibility_off
                                : Icons.visibility)
                            : null,
                      ),
                    ),
                  )
                : null,
            hintStyle: TextStyle(color: Color(0xF0BDBDBD)),
            contentPadding: EdgeInsets.symmetric(horizontal: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                borderSide: BorderSide.none)
            // filled: true,
            // fillColor: Color(0xF0BBBBBB),
            ),
      ),
    );
  }
}
