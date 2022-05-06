import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<ImageSource?> showDialogPickImageSource(BuildContext context) async {
  return await showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: const DialogImagePicker(),
      );
    },
  );
}

class DialogImagePicker extends StatefulWidget {
  const DialogImagePicker({Key? key}) : super(key: key);

  @override
  State<DialogImagePicker> createState() => _DialogImagePickerState();
}

class _DialogImagePickerState extends State<DialogImagePicker> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.onSecondary,
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          margin: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                "Select Image Source",
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 0,
                    child: Ink(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context, ImageSource.camera);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          color: Theme.of(context).colorScheme.onBackground,
                          child: Column(
                            children: [
                              Icon(
                                Icons.camera_alt_rounded,
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryVariant,
                                size: 40,
                              ),
                              const Text("Camera")
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 0,
                    child: Ink(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context, ImageSource.gallery);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          color: Theme.of(context).colorScheme.onBackground,
                          child: Column(
                            children: [
                              Icon(
                                Icons.folder_open,
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryVariant,
                                size: 40,
                              ),
                              const Text("Gallery")
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
