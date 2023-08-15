import 'package:flutter/material.dart';

class RaisedFormField extends StatefulWidget {
  const RaisedFormField({
    super.key,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.label,
    this.prefixIcon,
    this.visibilityButtonEnabled = false,
    this.suffixIcon,
    this.onSaved,
    this.keyboardType,
  });

  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final String? label;
  final Widget? prefixIcon;
  final bool visibilityButtonEnabled;
  final Widget? suffixIcon;
  final void Function(String?)? onSaved;
  final TextInputType? keyboardType;

  @override
  State<RaisedFormField> createState() => _RaisedFormFieldState();
}

class _RaisedFormFieldState extends State<RaisedFormField> {
  bool _textObscured = false;
  @override
  void initState() {
    _textObscured = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(105),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 10,
            offset: Offset(0, 3),
            spreadRadius: 3,
          )
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        obscureText: _textObscured,
        decoration: InputDecoration(
          label: (widget.label != null) ? Text(widget.label!) : null,
          border: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide.none,
          ),
          prefixIcon: widget.prefixIcon,
          suffixIcon: (widget.visibilityButtonEnabled)
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _textObscured = !_textObscured;
                    });
                  },
                  icon: Icon((_textObscured)
                      ? Icons.visibility_off
                      : Icons.visibility),
                )
              : widget.suffixIcon,
        ),
        onSaved: widget.onSaved,
      ),
    );
  }
}
