import 'package:attention/core/enums/app_state.dart';
import 'package:attention/core/enums/gender.dart';
import 'package:attention/core/providers/app_state_data_provider.dart';
import 'package:attention/core/user/user.dart';
import 'package:attention/core/user/user_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  int _currentStep = 1;
  final int _maxStep = 5;

  bool get _continueButtonEnabled {
    if (_currentStep == 1) {
      return verifyStep1();
    } else if (_currentStep == 2) {
      return verifyStep2();
    } else if (_currentStep == 3) {
      return verifyStep3();
    } else if (_currentStep == 4) {
      return verifyStep4();
    } else if (_currentStep == 5) {
      return verifyStep5();
    }

    return false;
  }

  DateTime _dateOfBirth = DateTime.now();
  bool _touchDateOfBirthPicker = false;

  Gender _selectedGender = Gender.male;

  // Step 1 : Full name
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;

  // Step 2 : Display Name and Gender
  late final TextEditingController _displayNameController;

  @override
  void initState() {
    super.initState();

    final user = ref.read(appStateDataProvider).user;

    _firstNameController = TextEditingController(
      text: user?.profile.firstName ?? '',
    );

    _lastNameController = TextEditingController(
      text: user?.profile.lastName ?? '',
    );

    _displayNameController = TextEditingController(
      text: user?.profile.displayName ?? _firstNameController.text,
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  void _onFieldChanged(String _) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(20),
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _currentStep != _maxStep
                      ? () {
                          if (_currentStep > 1) {
                            setState(() {
                              _currentStep--;
                            });
                          }
                        }
                      : null,
                  child: Text("<"),
                ),
                Expanded(
                  child: LinearProgressIndicator(
                    value: _currentStep / _maxStep,
                    minHeight: 20,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
            switch (_currentStep) {
              1 => _step1(),
              2 => _step2(),
              3 => _step3(),
              4 => _step4(),
              5 => _step5(),
              _ => throw StateError,
            },
            ElevatedButton(
              onPressed: _continueButtonEnabled
                  ? () {
                      if (_currentStep == _maxStep) {
                        ref.read(appStateDataProvider.notifier).setState(AppState.home);
                      } else if (_currentStep == _maxStep - 1) {
                        User user = User(
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                          displayName: _displayNameController.text,
                          gender: _selectedGender,
                          dateOfBirth: _dateOfBirth,
                        );
                        ref.read(appStateDataProvider.notifier).setUser(user);
                        setState(() {
                          _currentStep++;
                        });
                        UserStorage.save(user);                       
                      } else {
                        setState(() {
                          _currentStep++;
                        });
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                fixedSize: Size(150, 50),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.secondary,
              ),
              child: Text(
                _currentStep != _maxStep ? "Continue" : "Finish",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _step1() {
    return Column(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Let's get to know you!", style: TextStyle(fontSize: 20)),
        TextField(
          controller: _firstNameController,
          decoration: const InputDecoration(
            labelText: "First name",
            labelStyle: TextStyle(fontSize: 20),
            helperText: "",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
          ),
          onChanged: _onFieldChanged,
        ),
        TextField(
          controller: _lastNameController,
          decoration: const InputDecoration(
            labelText: "Last name",
            labelStyle: TextStyle(fontSize: 20),
            helperText: "",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
          ),
          onChanged: _onFieldChanged,
        ),
      ],
    );
  }

  Column _step2() {
    return Column(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("What should we call you?", style: TextStyle(fontSize: 20)),
        TextField(
          controller: _displayNameController,
          decoration: const InputDecoration(
            labelText: "Nickname",
            labelStyle: TextStyle(fontSize: 20),
            helperText: "",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
          ),
          onChanged: _onFieldChanged,
        ),
        Text("Gender", style: TextStyle(fontSize: 20)),
        RadioGroup<Gender>(
          groupValue: _selectedGender,
          onChanged: (Gender? value) {
            if (value == null) return;

            setState(() {
              _selectedGender = value;
            });
          },
          child: Column(
            children: Gender.values.map((gender) {
              return RadioListTile<Gender>(
                title: Text(gender.label),
                value: gender,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Column _step3() {
    return Column(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Your birthday", style: TextStyle(fontSize: 20)),
        CalendarDatePicker(
          initialDate: _dateOfBirth,
          firstDate: DateTime.fromMillisecondsSinceEpoch(0),
          lastDate: DateTime.now(),
          onDateChanged: (DateTime value) {
            setState(() {
              _touchDateOfBirthPicker = true;
              _dateOfBirth = value;
            });
          },
        ),
        Text(
          _touchDateOfBirthPicker
              ? "${_dateOfBirth.year}-${_dateOfBirth.month}-${_dateOfBirth.day}, is that correct?"
              : "",
        ),
      ],
    );
  }

  Column _step4() {
    return Column(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Recheck your infomation", style: TextStyle(fontSize: 20)),
        Divider(),
        Text("${_firstNameController.text} ${_lastNameController.text}"),
        Text(_displayNameController.text),
        Text(_selectedGender.label),
        Text(
          "${_dateOfBirth.year.toString()}-${_dateOfBirth.month.toString()}-${_dateOfBirth.day.toString()}",
        ),
        Divider(),
        Text("Once you press 'Continue', this can't be undone!"),
      ],
    );
  }

  Column _step5() {
    return Column(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(Icons.celebration_rounded, size: 100,),
        Text("All done!", style: TextStyle(fontSize: 40)),
        Text("Welcome to Attention, ${ref.read(appStateDataProvider).user?.profile.displayName}.", style: TextStyle(fontSize: 20)),
      ],
    );
  }

  bool verifyStep1() {
    return _firstNameController.text.trim().isNotEmpty &&
        _lastNameController.text.trim().isNotEmpty;
  }

  bool verifyStep2() {
    return _displayNameController.text.trim().isNotEmpty;
  }

  bool verifyStep3() => true;

  bool verifyStep4() => true;

  bool verifyStep5() => true;
}
