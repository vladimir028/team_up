import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_up/data/account/sport_selection/sport.dart';
import 'package:team_up/data/account/sport_selection/sport_selection.dart';
import 'package:team_up/models/enum/court_type.dart';
import 'package:team_up/models/location_data.dart';
import 'package:team_up/presentation/widgets/input_field.dart';
import 'package:team_up/service/auth_service.dart';
import 'package:team_up/service/sport_service.dart';
import 'package:toastification/toastification.dart';

import '../../../global/toast.dart';
import '../../../models/sport_event.dart';
import '../../../styles/my_colors.dart';
import '../../widgets/dropdownlist.dart';
import '../../widgets/navigation_bottom.dart';
import '../../widgets/navigation_routes.dart';
import '../../widgets/player_counter.dart';
import '../../widgets/styled_button.dart';

class SportForm extends StatefulWidget {
  const SportForm({super.key});

  @override
  SportFormState createState() => SportFormState();
}

class SportFormState extends State<SportForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _scheduledTimeStartController =
  TextEditingController();
  final TextEditingController _scheduledTimeEndController =
  TextEditingController();
  final TextEditingController _pricePerHourController = TextEditingController();
  final TextEditingController _totalPlayersController = TextEditingController();
  final TextEditingController _missingPlayersController =
  TextEditingController();
  final TextEditingController latController = TextEditingController();
  final TextEditingController lngController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay scheduledTimeStart = TimeOfDay.now();
  TimeOfDay scheduledTimeEnd = TimeOfDay.now();
  CourtType selectedCourtType = CourtType.indoor;
  Sport selectedSport = SportSelection.sports[0];

  late LocationData? locationData;
  SportService sportService = SportService();
  AuthService authService = AuthService();

  void _pickTime(TextEditingController controller, TimeOfDay? scheduledTime,
      Function(TimeOfDay) updateScheduledTime) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: scheduledTime ?? TimeOfDay.now(),
    );
    if (selectedTime != null && mounted) {
      final formattedTime = selectedTime.format(context);
      setState(() {
        controller.text = formattedTime;
        updateScheduledTime(
            TimeOfDay(hour: selectedTime.hour, minute: selectedTime.minute));
      });
    }
  }

  bool isAfter(TimeOfDay time1, TimeOfDay time2) {
    int minutes1 = time1.hour * 60 + time1.minute;
    int minutes2 = time2.hour * 60 + time2.minute;
    return minutes1 > minutes2;
  }

  Future<void> _selectDate(BuildContext context,
      FormFieldState<DateTime> state) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        state.didChange(selectedDate);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute
        .of(context)
        ?.settings
        .arguments != null) {
      locationData = ModalRoute
          .of(context)
          ?.settings
          .arguments as LocationData;
    } else {
      locationData = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sport Form")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: MyDropdownButton<Sport>(
                        value: selectedSport,
                        items: SportSelection.sports,
                        onChanged: (Sport? newValue) {
                          setState(() {
                            selectedSport = newValue!;
                          });
                        },
                        itemLabel: (sport) => sport.name,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: MyDropdownButton<CourtType>(
                        value: selectedCourtType,
                        items: CourtType.values,
                        onChanged: (CourtType? newValue) {
                          setState(() {
                            selectedCourtType = newValue!;
                          });
                        },
                        itemLabel: (courtType) =>
                        courtType
                            .toString()
                            .split('.')
                            .last,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                FormField<DateTime>(
                  builder: (FormFieldState<DateTime> state) {
                    return Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StyledButton(
                          onPressed: () => _selectDate(context, state),
                          label: selectedDate == null
                              ? "Select Date"
                              : "${selectedDate!.toLocal()}".split(' ')[0],
                        ),
                        if (state.hasError)
                          Text(
                            state.errorText ?? '',
                            style: TextStyle(color: MyColors.support.formError),
                          ),
                      ],
                    );
                  },
                  validator: (value) {
                    if (selectedDate == null) {
                      return 'Please select a date';
                    }
                    if (selectedDate!.isBefore(DateTime.now())) {
                      return 'The date must be today or in the future';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _scheduledTimeStartController,
                        decoration: InputDecoration(hintText: "Starting time"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter start time';
                          }
                          TimeOfDay time = TimeOfDay(
                              hour: int.parse(value.split(":")[0]),
                              minute: int.parse(value.split(":")[1]));
                          if (!isAfter(time, TimeOfDay.now())) {
                            return 'Time must be in the future';
                          }
                          return null;
                        },
                        onTap: () =>
                            _pickTime(
                              _scheduledTimeStartController,
                              scheduledTimeStart,
                                  (newTime) {
                                setState(() {
                                  scheduledTimeStart = newTime;
                                });
                              },
                            ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _scheduledTimeEndController,
                        decoration: InputDecoration(hintText: "Ending time"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter end time';
                          }
                          TimeOfDay time = TimeOfDay(
                              hour: int.parse(value.split(":")[0]),
                              minute: int.parse(value.split(":")[1]));
                          if (!isAfter(time, scheduledTimeStart)) {
                            return 'Time must be after start';
                          }
                          return null;
                        },
                        onTap: () =>
                            _pickTime(
                              _scheduledTimeEndController,
                              scheduledTimeEnd,
                                  (newTime) {
                                setState(() {
                                  scheduledTimeEnd = newTime;
                                });
                              },
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _pricePerHourController,
                  decoration: InputDecoration(hintText: "Price Per Hour"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price per hour';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Price must be a number';
                    }
                    if (int.tryParse(value)!.isNegative) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                  onChanged: (value){
                    setState(() {
                      _pricePerHourController.text = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                StyledButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/map_picker'),
                    label: locationData?.name ?? 'Choose Location'),
                // InputField(
                //   controller: latController,
                //   hintText: "Latitude",
                //   keyboardType: TextInputType.number,
                // ),
                // const SizedBox(height: 16),
                // InputField(
                //   controller: lngController,
                //   hintText: "Longitude",
                //   keyboardType: TextInputType.number,
                // ),
                const SizedBox(height: 24),
                Row(children: [
                  Expanded(
                    child: PlayerCounterWidget(
                      labelText: "Total Players As Of Now",
                      controller: _totalPlayersController,
                      onIncrement: () {
                        setState(() {
                          int currentValue =
                              int.tryParse(_totalPlayersController.text) ?? 0;
                          _totalPlayersController.text =
                              (currentValue + 1).toString();
                        });
                      },
                      onDecrement: () {
                        setState(() {
                          int currentValue =
                              int.tryParse(_totalPlayersController.text) ?? 0;
                          _totalPlayersController.text = (currentValue - 1)
                              .clamp(0, double.infinity)
                              .toString();
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: PlayerCounterWidget(
                      labelText: "Missing Players",
                      controller: _missingPlayersController,
                      onIncrement: () {
                        setState(() {
                          int currentValue =
                              int.tryParse(_missingPlayersController.text) ?? 0;
                          _missingPlayersController.text =
                              (currentValue + 1).toString();
                        });
                      },
                      onDecrement: () {
                        setState(() {
                          int currentValue =
                              int.tryParse(_missingPlayersController.text) ?? 0;
                          _missingPlayersController.text = (currentValue - 1)
                              .clamp(0, double.infinity)
                              .toString();
                        });
                      },
                    ),
                  ),
                ]),
                const SizedBox(height: 30),
                // Submit button
                NavigationRoutes(
                  descriptionButton: "Submit",
                  routeButton: "/home",
                  descriptionRegular: "",
                  descriptionBold: "",
                  descriptionRoute: "",
                  onTap: addSportEvent,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const NavigationBarBottom(currentPage: 3),
    );
  }

  void addSportEvent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    SportEvent? savedSport = await sportService.addSport(
        selectedSport.name,
        selectedSport.imgUrl,
        calculateMinutesDifference(scheduledTimeEnd, scheduledTimeStart),
        _pricePerHourController.text,
        _totalPlayersController.text,
        _missingPlayersController.text,
        authService
            .getCurrentUser()
            .uid,
        GeoPoint(locationData?.latitude ?? 0, locationData?.longitude ?? 0),
        locationData?.name ?? "",
        scheduledTimeStart,
        scheduledTimeEnd,
        selectedDate,
        selectedCourtType);
    if (savedSport != null && mounted) {
      Toast toast = Toast(
          ToastificationType.success,
          "Sport event created successfully",
          "You can edit your event in the future",
          Icons.check,
          MyColors.support.success);
      toast.showToast();

      Navigator.pushNamed(context, "/home");
    }
  }

  int calculateMinutesDifference(TimeOfDay scheduledTimeEnd,
      TimeOfDay scheduledTimeStart) {
    int startMinutes = scheduledTimeStart.hour * 60 + scheduledTimeStart.minute;
    int endMinutes = scheduledTimeEnd.hour * 60 + scheduledTimeEnd.minute;

    return (endMinutes - startMinutes).abs();
  }
}
