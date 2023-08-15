import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BannerHeader extends StatelessWidget {
  const BannerHeader({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Theme.of(context).colorScheme.primary,
          Theme.of(context).colorScheme.secondaryContainer,
        ]),
        color: Theme.of(context).colorScheme.primary,
      ),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 100, 10, 60),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 50,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
