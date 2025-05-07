// profile_view

import 'dart:io';

import 'package:crud_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:crud_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:crud_app/services/firebase_service.dart';
import 'package:crud_app/services/r2_service.dart';
import 'package:crud_app/ui/typography/text_heading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});
  @override
  State<StatefulWidget> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final FirebaseService _firebaseService = FirebaseService();
  final R2Service _r2Service = R2Service(bucketName: 'scp-app');

  bool isLoading = false;
  bool isEditing = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Initial values for the fields. For comparison with the new values, if any.
  String? userId;
  String? initialProfilePictureURL;
  String? initialName;
  String? initialEmail;
  User? currentUser;

  String? newProfileImagePath;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final oldPasswordController = TextEditingController();
  String? oldPasswordError;
  String? newPasswordError;
  String? confirmPasswordError;
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _r2Service.initialize();
    // enable new password only when old password is filled
    oldPasswordController.addListener(() {
      setState(() {
        newPasswordController.text =
            oldPasswordController.text.isNotEmpty
                ? newPasswordController.text
                : '';
      });
    });

    // enable confirm new password only when new password is filled
    newPasswordController.addListener(() {
      setState(() {
        confirmNewPasswordController.text =
            newPasswordController.text.isNotEmpty
                ? confirmNewPasswordController.text
                : '';
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUserData(); // Fetch user data after the widget is built
    });
  }

  void _fetchUserData() async {
    // TODO: get profile picture URL from Cloudflare R2 and set it to initialProfilePictureURL
    setState(() {
      isLoading = true; // Show loading indicator
    });

    try {
      // Wait for the Future to resolve
      final currentUser = await context.read<AuthBloc>().getCurrentUser();

      if (currentUser != null) {
        // Populate the controllers with user details
        userId = currentUser.uid;
        initialProfilePictureURL = await _firebaseService
            .getUserProfilePictureURL(userId!); // Set the profile picture URL
        print('Initial Profile Picture URL: $initialProfilePictureURL');
        nameController.text = currentUser.name ?? '';
        initialName = currentUser.name;
        emailController.text = currentUser.email ?? '';
        initialEmail = currentUser.email;
      } else {}
    } catch (e) {
      print('Error fetching user data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _pickAndStoreImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        setState(() {
          newProfileImagePath = pickedFile.path;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<String?> _verifyPassword(String testPassword) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      AuthCredential credential = EmailAuthProvider.credential(
        email: initialEmail!,
        password: oldPasswordController.text,
      );

      await currentUser?.reauthenticateWithCredential(credential);
      print('Reauthentication successful.');
      return null; // Password is correct
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        return 'Incorrect password. Please try again.';
      }
      return e.message;
    } catch (e) {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  Future<String?> _updatePassword(String newPassword) async {
    try {
      await FirebaseAuth.instance.currentUser?.updatePassword(newPassword);
      print('Password updated successfully.');
      return null; // Password updated successfully
    } on FirebaseAuthException catch (e) {
      return 'Error updating password: ${e.message}';
    } catch (e) {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  void _updateUserData() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    try {
      // Verify old password if provided
      if (oldPasswordController.text.isNotEmpty) {
        final passwordError = await _verifyPassword(oldPasswordController.text);
        if (passwordError != null) {
          setState(() {
            oldPasswordError = passwordError;
          });
          return;
        } else {
          setState(() {
            oldPasswordError = null;
          });

          // Update password
          final updatePasswordError = await _updatePassword(
            newPasswordController.text,
          );
          if (updatePasswordError != null) {
            setState(() {
              newPasswordError = updatePasswordError;
            });
            return;
          } else {
            setState(() {
              newPasswordError = null;
            });
          }
        }
      }

      // Update profile picture if changed
      if (newProfileImagePath != null &&
          File(newProfileImagePath!).existsSync()) {
        String fileExtension = newProfileImagePath!.split('.').last;
        String newFileName =
            "${DateTime.now().millisecondsSinceEpoch}.$fileExtension";

        try {
          final slug = Uri.parse(initialProfilePictureURL!).pathSegments.last;
          await _r2Service.deleteFile(slug);
        } catch (e) {
          print('Error deleting old profile picture: $e');
        }

        try {
          File file = File(newProfileImagePath!);
          await _firebaseService.deleteUserProfilePictureURL(userId!);
          final uploadedFileURL = await _r2Service.uploadFile(
            file,
            newFileName,
          );

          if (uploadedFileURL != null) {
            print('Profile picture uploaded: $uploadedFileURL');
            await _firebaseService.updateUserProfilePictureURL(
              userId!,
              uploadedFileURL,
            );
            print("Profile picture URL updated in database: $uploadedFileURL");
          } else {
            print('Failed to upload profile picture.');
          }
        } catch (e) {
          print('Error uploading profile picture: $e');
        }
      }

      bool needsReauthentication = false;
      // Update name if changed
      if (nameController.text != initialName) {
        needsReauthentication = true;
        print(
          await _firebaseService.updateUserName(userId!, nameController.text),
        );
        // print('Name updated: ${nameController.text}');
      }

      // Update email if changed
      if (emailController.text != initialEmail) {
        needsReauthentication = true;
        print(
          await _firebaseService.updateUserEmail(userId!, emailController.text),
        );
      }

      if (needsReauthentication) {
        // Reauthenticate the user after updating the email
        // logout the user
        context.read<AuthBloc>().add(LogoutEvent());
      }

      // Navigate only after all operations are complete
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(builder: (context) => const ProfileView()),
      // );
    } catch (e) {
      print('Error updating user data: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something went wrong')));
    }
  }

  void _clearForm() {
    setState(() {
      newProfileImagePath = null;
      nameController.text = initialName ?? '';
      emailController.text = initialEmail ?? '';
      oldPasswordController.clear();
      newPasswordController.clear();
      confirmNewPasswordController.clear();
      isEditing = false;
    });
  }

  @override
  void dispose() {
    oldPasswordController.removeListener(() {});
    newPasswordController.removeListener(() {});

    nameController.dispose();
    emailController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  TextHeading(
                    text: isEditing ? 'Edit Profile' : 'Profile',
                    style: TextStyle(fontSize: 30),
                    fontName: 'Grenze Gotisch',
                  ),
                  Spacer(),
                  if (isEditing) ...[
                    // Cancel button
                    ElevatedButton.icon(
                      onPressed: _clearForm,
                      label: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.yellow),
                      ),
                      icon: Icon(Icons.cancel, color: Colors.yellow),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        side: BorderSide(color: Colors.yellow, width: 2),
                        elevation: 0,
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                  if (!isEditing) ...[
                    // Edit button
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          isEditing = true;
                        });
                      },
                      icon: Icon(
                        Icons.edit,
                        color: isEditing ? Color(0xff350f0f) : Colors.yellow,
                      ),
                      label: Text(
                        'Edit',
                        style: TextStyle(
                          color: isEditing ? Color(0xff350f0f) : Colors.yellow,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        side: BorderSide(color: Colors.yellow, width: 2),
                        elevation: 0,
                      ),
                    ),
                  ] else ...[
                    // Save button
                    ElevatedButton.icon(
                      onPressed: _updateUserData,
                      icon: Icon(Icons.save, color: Color(0xff350f0f)),
                      label: Text(
                        isEditing ? 'Save' : 'Edit',
                        style: TextStyle(
                          color: isEditing ? Color(0xff350f0f) : Colors.yellow,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isEditing ? Colors.yellow : Colors.transparent,
                        side: BorderSide(
                          color: Colors.yellow,
                          width: isEditing ? 0 : 2,
                        ),
                        elevation: 0,
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 24),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage:
                          /**
                       * Check if there is a new profile image
                       * else check if there is an initial profile picture URL
                       * else use the placeholder/default
                       */
                          (newProfileImagePath != null)
                              ? FileImage(File(newProfileImagePath!))
                              : (initialProfilePictureURL != null
                                      ? NetworkImage(initialProfilePictureURL!)
                                      : const AssetImage(
                                        'assets/images/profile_placeholder.jpg',
                                      ))
                                  as ImageProvider,
                      backgroundColor: Colors.grey[200],
                    ),
                    if (isEditing)
                      ClipOval(
                        child: Material(
                          color: Colors.black.withAlpha(128),
                          child: InkWell(
                            onTap: _pickAndStoreImage,
                            child: SizedBox(
                              width:
                                  120, // Diameter of the CircleAvatar (2 * radius)
                              height: 120,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .center, // Center vertically
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .center, // Center horizontally
                                  children: [
                                    Icon(
                                      Icons.upload,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    Text(
                                      newProfileImagePath != null
                                          ? 'Reupload'
                                          : 'Upload',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                enabled: isEditing,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                enabled: isEditing,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(
                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                  ).hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              TextFormField(
                controller: oldPasswordController,
                decoration: InputDecoration(
                  labelText: isEditing ? 'Old Password' : 'Password',
                  border: OutlineInputBorder(),
                  hintText: isEditing ? null : '-',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  errorText: oldPasswordError,
                ),
                obscureText: true,
                enabled: isEditing,
              ),
              if (isEditing) ...[
                SizedBox(height: 24),
                TextFormField(
                  controller: newPasswordController,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    errorText: newPasswordError,
                  ),
                  obscureText: true,
                  enabled: isEditing && oldPasswordController.text.isNotEmpty,
                  validator: (value) {
                    /**
                     * Only validate new password if old password is filled
                     * Check if new password is empty or less than 8 characters
                     */
                    if (oldPasswordController.text.isNotEmpty) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a new password';
                      } else if (value.length < 8) {
                        return 'Password must be at least 8 characters long';
                      }
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                TextFormField(
                  controller: confirmNewPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm New Password',
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    errorText: confirmPasswordError,
                  ),
                  obscureText: true,
                  enabled: isEditing && newPasswordController.text.isNotEmpty,
                  validator: (value) {
                    /**
                     * Only validate confirm new password if new password is filled
                     * Check if confirm new password is empty or not equal to new password
                     */
                    if (newPasswordController.text.isNotEmpty) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your new password';
                      } else if (value != newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                    }
                    return null;
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
