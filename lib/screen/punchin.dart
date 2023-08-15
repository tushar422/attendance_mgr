import 'dart:io';

import 'package:attendance_mgr/model/latlng.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class PunchInSheet extends StatefulWidget {
  const PunchInSheet({
    super.key,
    required this.onSuccess,
  });
  final void Function(DateTime) onSuccess;
  @override
  State<PunchInSheet> createState() => _PunchInSheetState();
}

class _PunchInSheetState extends State<PunchInSheet> {
  File? _selectedImage;
  bool _hasError = false;
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
      child: Column(
        children: [
          Container(
            height: 300,
            clipBehavior: Clip.hardEdge,
            // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  width: 0.5, color: Theme.of(context).primaryColorDark),
            ),
            child: InkWell(
              onTap: _takePhoto,
              child: (_selectedImage != null)
                  ? Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    )
                  : Center(
                      child: TextButton.icon(
                        label: const Text('No Image selected.'),
                        icon: const Icon(Icons.camera_alt),
                        onPressed: _takePhoto,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: (_selectedImage != null) ? _submit : null,
            icon: const Icon(Icons.done),
            label: (_submitting)
                ? const LinearProgressIndicator()
                : Text(
                    (_selectedImage != null) ? 'Submit' : 'Add your photo',
                  ),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll(Theme.of(context).primaryColorLight),
            ),
          )
        ],
      ),
    );
  }

  void _takePhoto() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      preferredCameraDevice: CameraDevice.front,
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if (pickedImage == null) return;
    setState(() {
      _selectedImage = File(pickedImage.path);
    });
    //widget.onSelect(_selectedImage);
  }

  void _submit() async {
    final user = FirebaseAuth.instance.currentUser!;
    final timestamp = Timestamp.now();

    setState(() {
      _submitting = true;
    });

    final location = await _getCurrentLocation();
    if (location == null) {
      setState(() {
        _hasError = true;
        _submitting = false;
        return;
      });
    }
    setState(() {
      _hasError = false;
    });

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('images')
        .child('${user.uid}_$timestamp.jpg');
    await storageRef.putFile(_selectedImage!);
    final imageUrl = await storageRef.getDownloadURL();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('attendance')
        .add({
      'timestamp': timestamp,
      'lat': location!.lat,
      'lng': location.lng,
      'image': imageUrl,
    });
    setState(() {
      _submitting = false;
    });
    widget.onSuccess!(timestamp.toDate());
    Navigator.pop(context, true);
  }

  Future<LatLng?> _getCurrentLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    locationData = await location.getLocation();

    if (locationData.latitude == null || locationData.longitude == null) {
      return null;
    }
    return LatLng(lat: locationData.latitude!, lng: locationData.longitude!);
  }
}
