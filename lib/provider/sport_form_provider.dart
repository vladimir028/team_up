import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toastification/toastification.dart';
import '../../../models/enum/court_type.dart';
import '../../../models/location_data.dart';
import '../../../models/sport_event.dart';
import '../../../data/account/sport_selection/sport.dart';
import '../../../service/auth_service.dart';
import '../../../service/sport_service.dart';
import '../../../global/toast.dart';
import '../data/account/sport_selection/sport_selection.dart';
import '../styles/my_colors.dart';

class SportFormProvider extends ChangeNotifier {
  final SportService sportService = SportService();
  final AuthService authService = AuthService();

  final TextEditingController scheduledTimeStartController =
      TextEditingController();
  final TextEditingController scheduledTimeEndController =
      TextEditingController();
  final TextEditingController pricePerHourController = TextEditingController();
  final TextEditingController totalPlayersController = TextEditingController();
  final TextEditingController missingPlayersController =
      TextEditingController();

  // final TextEditingController latController = TextEditingController();
  // final TextEditingController lngController = TextEditingController();

  String? pricePerHour;
  String? totalPlayers;
  String? missingPlayers;
  DateTime? selectedDate;
  TimeOfDay? scheduledTimeStart = TimeOfDay.now();
  TimeOfDay? scheduledTimeEnd = TimeOfDay(
      hour: TimeOfDay.now().hour + 1 % 24,
      minute: TimeOfDay.now().minute); //One hour later
  CourtType selectedCourtType = CourtType.indoor;
  Sport selectedSport = SportSelection.sports[0];
  LocationData? locationData;

  void initControllers() {
    scheduledTimeStartController.text = formatTime(scheduledTimeStart);
    scheduledTimeEndController.text = formatTime(scheduledTimeEnd);
    pricePerHourController.addListener(() {
      pricePerHour = pricePerHourController.text;
    });
    totalPlayersController.addListener(() {
      totalPlayers = totalPlayersController.text;
    });
    missingPlayersController.addListener(() {
      missingPlayers = missingPlayersController.text;
    });
  }

  String formatTime(TimeOfDay? time) {
    if (time != null) {
      String hour = time.hour.toString().padLeft(2, '0');
      String minute = time.minute.toString().padLeft(2, '0');
      return "$hour:$minute";
    }
    return "";
  }

  Future<void> pickTime(BuildContext context, bool isStartTime) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      isStartTime ? updateTimeStart(selectedTime) : updateTimeEnd(selectedTime);
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      updateSelectedDate(picked);
    }
  }

  bool isAfter(TimeOfDay time1, TimeOfDay time2) {
    int minutes1 = time1.hour * 60 + time1.minute;
    int minutes2 = time2.hour * 60 + time2.minute;
    return minutes1 > minutes2;
  }

  void addSportEvent() async {
    SportEvent? savedSport = await sportService.addSport(
      selectedSport.name,
      selectedSport.imgUrl,
      calculateMinutesDifference(scheduledTimeEnd!, scheduledTimeStart!),
      pricePerHour!,
      totalPlayers!,
      missingPlayers!,
      authService.getCurrentUser().uid,
      GeoPoint(locationData?.latitude ?? 0, locationData?.longitude ?? 0),
      locationData?.name ?? "",
      scheduledTimeStart!,
      scheduledTimeEnd!,
      selectedDate,
      selectedCourtType,
    );

    if (savedSport != null) {
      Toast toast = Toast(
          ToastificationType.success,
          "Sport Event created successfully",
          "Others can now join your event.",
          Icons.check,
          MyColors.support.success);
      toast.showToast();
      resetFormData();
    } else {
      Toast toast = Toast(ToastificationType.error, "Error creating event",
          "Please try again.", Icons.error, MyColors.support.error);
      toast.showToast();
    }
  }

  int calculateMinutesDifference(TimeOfDay end, TimeOfDay start) {
    int startMinutes = start.hour * 60 + start.minute;
    int endMinutes = end.hour * 60 + end.minute;
    return (endMinutes - startMinutes).abs();
  }

  void updateTimeStart(TimeOfDay selectedTime) {
    scheduledTimeStart = selectedTime;
    scheduledTimeStartController.text = formatTime(scheduledTimeStart);
    notifyListeners();
  }

  void updateTimeEnd(TimeOfDay selectedTime) {
    scheduledTimeEnd = selectedTime;
    scheduledTimeEndController.text = formatTime(scheduledTimeEnd);
    notifyListeners();
  }

  void updateSelectedDate(DateTime picked) {
    selectedDate = picked;
    notifyListeners();

  }

  void updateSelectedCourtType(CourtType courtType) {
    selectedCourtType = courtType;
    notifyListeners();
  }

  void updateSelectedSport(Sport sport) {
    selectedSport = sport;
    notifyListeners();
  }

  void updatePricePerHour(String? value) {
    pricePerHour = value;
    pricePerHourController.text = pricePerHour!;
    notifyListeners();
  }

  void increaseTotalPlayers() {
    int currentValue = int.tryParse(totalPlayersController.text) ?? 0;
    totalPlayers = (currentValue + 1).toString();
    totalPlayersController.text = totalPlayers!;
    notifyListeners();
  }

  void decreaseTotalPlayers() {
    int currentValue = int.tryParse(totalPlayersController.text) ?? 0;
    totalPlayers = (currentValue - 1).clamp(0, double.infinity).toString();
    totalPlayersController.text = totalPlayers!;
    notifyListeners();
  }

  void increaseMissingPlayers() {
    int currentValue = int.tryParse(missingPlayersController.text) ?? 0;
    missingPlayers = (currentValue + 1).toString();
    missingPlayersController.text = missingPlayers!;
    notifyListeners();
  }

  void decreaseMissingPlayers() {
    int currentValue = int.tryParse(missingPlayersController.text) ?? 0;
    missingPlayers = (currentValue - 1).clamp(0, double.infinity).toString();
    missingPlayersController.text = missingPlayers!;
    notifyListeners();
  }

  void resetFormData() {
    scheduledTimeStartController.clear();
    scheduledTimeEndController.clear();
    pricePerHourController.clear();
    totalPlayersController.clear();
    missingPlayersController.clear();

    pricePerHour = null;
    totalPlayers = null;
    missingPlayers = null;
    scheduledTimeStart = null;
    scheduledTimeEnd = null;
    selectedDate = null;

  }
}
