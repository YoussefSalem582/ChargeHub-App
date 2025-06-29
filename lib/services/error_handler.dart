import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppError {
  final String message;
  final String? code;
  final ErrorType type;

  AppError({required this.message, this.code, this.type = ErrorType.general});
}

enum ErrorType { network, authentication, location, firestore, general }

class ErrorHandler {
  static AppError handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return AppError(
          message: 'No account found with this email address.',
          code: e.code,
          type: ErrorType.authentication,
        );
      case 'wrong-password':
        return AppError(
          message: 'Incorrect password. Please try again.',
          code: e.code,
          type: ErrorType.authentication,
        );
      case 'email-already-in-use':
        return AppError(
          message: 'An account already exists with this email address.',
          code: e.code,
          type: ErrorType.authentication,
        );
      case 'weak-password':
        return AppError(
          message: 'Password is too weak. Please choose a stronger password.',
          code: e.code,
          type: ErrorType.authentication,
        );
      case 'invalid-email':
        return AppError(
          message: 'Please enter a valid email address.',
          code: e.code,
          type: ErrorType.authentication,
        );
      case 'network-request-failed':
        return AppError(
          message: 'Network error. Please check your internet connection.',
          code: e.code,
          type: ErrorType.network,
        );
      default:
        return AppError(
          message: 'An authentication error occurred. Please try again.',
          code: e.code,
          type: ErrorType.authentication,
        );
    }
  }

  static AppError handleGeneralError(dynamic error) {
    if (error is FirebaseAuthException) {
      return handleFirebaseAuthError(error);
    }

    return AppError(
      message: 'An unexpected error occurred. Please try again.',
      type: ErrorType.general,
    );
  }

  static void showErrorDialog(BuildContext context, AppError error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(34, 37, 45, 1),
          title: Row(
            children: [
              Icon(_getErrorIcon(error.type), color: Colors.redAccent),
              const SizedBox(width: 8),
              const Text('Error', style: TextStyle(color: Colors.white)),
            ],
          ),
          content: Text(
            error.message,
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  static void showSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  static void showWarningSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  static IconData _getErrorIcon(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return Icons.wifi_off;
      case ErrorType.authentication:
        return Icons.account_circle;
      case ErrorType.location:
        return Icons.location_off;
      case ErrorType.firestore:
        return Icons.cloud_off;
      case ErrorType.general:
      default:
        return Icons.error;
    }
  }
}
