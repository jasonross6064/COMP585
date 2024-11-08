import 'package:permission_handler/permission_handler.dart';

Future<void> _requestPermissions() async {
  // Check and request storage permissions
  PermissionStatus status = await Permission.storage.request();

  if (status.isGranted) {
    // Permissions granted, continue with your functionality
  } else {
    // Permissions denied, handle appropriately
    print("Permission denied");
  }
}
