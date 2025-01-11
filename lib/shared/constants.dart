import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

/// Parses the message and applies text styles
TextSpan parseStyledText(String message) {
  List<TextSpan> spans = [];

  // Regex for Bold (**bold**), Italic (*italic*), and Headings (# Heading)
  final boldRegex = RegExp(r'\*\*(.*?)\*\*'); 
  final italicRegex = RegExp(r'\*(.*?)\*');
  final headingRegex = RegExp(r'^(#{1,6})\s+(.*)');

  int start = 0;

  // Step 1: Handle Headings
  final headingMatch = headingRegex.firstMatch(message);
  if (headingMatch != null) {
    final level = headingMatch.group(1)!.length;  // Heading level (# = H1, ## = H2, etc.)
    final text = headingMatch.group(2)!;

    // Add heading styling
    spans.add(TextSpan(
      text: "$text\n",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 26 - (level * 2),  // H1 is largest, H6 is smallest
        color: Colors.black87,
      ),
    ));

    // Continue parsing remaining text
    message = message.substring(headingMatch.end);
  }

  // Step 2: Parse Bold and Italic
  final combinedRegex = RegExp(r'\*\*(.*?)\*\*|\*(.*?)\*');
  for (final match in combinedRegex.allMatches(message)) {
    if (match.start > start) {
      spans.add(TextSpan(text: message.substring(start, match.start)));
    }

    if (match.group(1) != null) {
      // Bold text
      spans.add(TextSpan(
        text: match.group(1),
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ));
    } else if (match.group(2) != null) {
      // Italic text
      spans.add(TextSpan(
        text: match.group(2),
        style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black),
      ));
    }

    start = match.end;
  }

  // Step 3: Add remaining text
  if (start < message.length) {
    spans.add(TextSpan(text: message.substring(start)));
  }

  return TextSpan(children: spans, style: TextStyle(color: Colors.black));
}
const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 1.5),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.5),
  ),
);

