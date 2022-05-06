import 'package:flutter/material.dart';
import 'package:tmdb_movie_app/controller/date_time_editing_controller.dart';
import 'package:tmdb_movie_app/models/user.dart';
import 'package:tmdb_movie_app/providers/profile_provider.dart';
import 'package:tmdb_movie_app/widgets/date_picker_button.dart';
import 'package:tmdb_movie_app/widgets/input_text_field.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController textNameController;
  late DateTimeEditingController dateTimeController;
  late TextEditingController textBirthPlaceController;

  @override
  void initState() {
    super.initState();
    User user = Provider.of<ProfileProvider>(context, listen: false).user;
    textNameController = TextEditingController(text: user.name);
    dateTimeController = DateTimeEditingController(dateTime: user.birthDate);
    textBirthPlaceController = TextEditingController(text: user.birthPlace);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: [
              Consumer<ProfileProvider>(builder: (context, model, child) {
                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    const SizedBox(height: 30),
                    Text(
                      "Name",
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 15),
                    InputTextField(
                      controller: textNameController,
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 5),
                    model.errorName != null
                        ? Text(
                            model.errorName!,
                            style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.red),
                          )
                        : const SizedBox(),
                    const SizedBox(height: 10),
                    Text(
                      "Birth Date",
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 15),
                    DatePickerButton(
                      controller: dateTimeController,
                    ),
                    const SizedBox(height: 5),
                    model.errorBirthDate != null
                        ? Text(
                            model.errorBirthDate!,
                            style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.red),
                          )
                        : const SizedBox(),
                    const SizedBox(height: 10),
                    Text(
                      "Birth Place",
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 15),
                    InputTextField(
                      controller: textBirthPlaceController,
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 5),
                    model.errorBirthPlace != null
                        ? Text(
                            model.errorBirthPlace!,
                            style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.red),
                          )
                        : const SizedBox(),
                    const SizedBox(height: 10),
                  ],
                );
              }),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: ElevatedButton(
                  onPressed: () {
                    String name = textNameController.text;
                    DateTime? dateTime = dateTimeController.dateTime;
                    String place = textBirthPlaceController.text;
                    Provider.of<ProfileProvider>(context, listen: false)
                        .verifyUserProfile(
                            name: name,
                            birthDate: dateTime,
                            birthPlace: place,
                            nextAction: () {
                              Navigator.of(context).pop();
                            });
                  },
                  child: const Text("Save Changes"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
