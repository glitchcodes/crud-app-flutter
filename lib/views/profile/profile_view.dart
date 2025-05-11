// joseph start
import 'dart:io';
import 'package:crud_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:crud_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:crud_app/services/firebase_service.dart';
import 'package:crud_app/services/r2_service.dart';
import 'package:crud_app/ui/typography/text_heading.dart';
import 'package:crud_app/util/toast_helper.dart';
import 'package:crud_app/views/profile/reauth_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});
  @override
  State<StatefulWidget> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final FirebaseService _firebaseService = FirebaseService();
  final R2Service _r2Service = R2Service(bucketName: 'scp-app');

  String? loadingText;
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
  // final oldPasswordController = TextEditingController();
  // String? oldPasswordError;
  String? emailError;
  String? newPasswordError;
  String? confirmPasswordError;
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _r2Service.initialize();
    newPasswordController.addListener(() {
      setState(() {});
    });

    // Fetch user data after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchUserData();
    });
  }

  Future<void> _fetchUserData() async {
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
            .getUserProfilePictureUrl(userId!); // Set the profile picture URL
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

  void _updateUserData() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    setState(() {
      loadingText = 'Updating...';
      isLoading = true;
    });

    final bool requireReauth =
        newPasswordController.text.isNotEmpty ||
        confirmNewPasswordController.text.isNotEmpty ||
        emailController.text != initialEmail;

    try {
      if (requireReauth) {
        final bool reauthResult = await showReauthDialog(context);
        if (!reauthResult) {
          if (mounted) {
            showToast(context, 'Requested operation requires reauthentication');
          }
          setState(() {
            isLoading = false;
          });
          return; // Cancel further processing
        } else {
          // Reauthentication successful
          // update email and/or password
          if (emailController.text != initialEmail) {
            try {
              await _firebaseService.updateUserEmail(emailController.text);
            } catch (e) {
              showToast(
                context,
                'Failed to update email',
                variant: ToastVariant.failed,
              );
              print('Error updating email: $e');
            }
            setState(() {
              emailError = null;
            });
          }

          if (newPasswordController.text.isNotEmpty) {
            if (newPasswordController.text !=
                confirmNewPasswordController.text) {
              setState(() {
                confirmPasswordError = 'Passwords do not match';
              });
              return;
            } else {
              try {
                await _firebaseService.updateUserPassword(
                  newPasswordController.text,
                );
              } catch (e) {
                showToast(
                  context,
                  'Failed to update password',
                  variant: ToastVariant.failed,
                );
              }

              setState(() {
                confirmPasswordError = null;
              });
            }
          }
        }
      }

      // Update profile picture URL
      if (newProfileImagePath != null &&
          File(newProfileImagePath!).existsSync()) {
        String fileExtension = newProfileImagePath!.split('.').last;
        String newFileName =
            "${DateTime.now().millisecondsSinceEpoch}.$fileExtension";

        if (initialProfilePictureURL != null) {
          try {
            final slug = Uri.parse(initialProfilePictureURL!).pathSegments.last;
            await _r2Service.deleteFile(slug);
          } catch (e) {
            showToast(
              context,
              'Failed to delete old profile picture',
              variant: ToastVariant.failed,
            );
            return;
          }
        }

        try {
          File file = File(newProfileImagePath!);
          await _firebaseService.deleteUserProfilePictureUrl(userId!);
          final uploadedFileURL = await _r2Service.uploadFile(
            file,
            newFileName,
          );

          if (uploadedFileURL != null) {
            await _firebaseService.updateUserProfilePictureUrl(
              userId!,
              uploadedFileURL,
            );
          } else {
            showToast(
              context,
              'Failed to update profile picture',
              variant: ToastVariant.failed,
            );
          }
        } catch (e) {
          showToast(
            context,
            'Failed to update profile picture',
            variant: ToastVariant.failed,
          );
        }
      }

      // Update name
      if (nameController.text != initialName) {
        try {
          await _firebaseService.updateUserName(nameController.text);
        } catch (e) {
          showToast(
            context,
            'Failed to update name',
            variant: ToastVariant.failed,
          );
        }
      }

      setState(() {
        loadingText = null;
        isLoading = false;
      });

      if (requireReauth) {
        await currentUser?.reload();
      }
      await _fetchUserData();
      _resetForm();
      showToast(
        context,
        'Profile updated successfully',
        variant: ToastVariant.success,
      );
    } catch (e) {
      print('Error updating user data: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something went wrong')));
    }
  }

  void _resetForm() {
    setState(() {
      newProfileImagePath = null;
      nameController.text = initialName ?? '';
      emailController.text = initialEmail ?? '';
      newPasswordController.clear();
      confirmNewPasswordController.clear();
      isEditing = false;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            if (loadingText != null) ...[
              SizedBox(height: 16),
              Text(loadingText!),
            ],
          ],
        ),
      );
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
                      onPressed: _resetForm,
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
                        'Save',
                        style: TextStyle(
                          color: isEditing ? Color(0xff350f0f) : Colors.yellow,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        side: BorderSide(color: Colors.yellow, width: 0),
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
                  errorText: emailError,
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
                enabled: isEditing,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (value.length < 8) {
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
          ),
        ),
      ),
    );
  }
}
