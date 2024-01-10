// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/screens/sign/auth_code_screen.dart';
import 'package:vetplus/services/user_service.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/utils/sign_utils.dart';
import 'package:vetplus/utils/validation_utils.dart';
import 'package:vetplus/widgets/common/custom_form_field.dart';
import 'package:vetplus/widgets/common/long_bottom_sheet.dart';

class RestorePasswordScreen extends StatefulWidget {
  const RestorePasswordScreen({
    super.key,
    required this.emailController,
  });

  final TextEditingController emailController;

  @override
  State<RestorePasswordScreen> createState() => _RestorePasswordScreenState();
}

class _RestorePasswordScreenState extends State<RestorePasswordScreen>
    with WidgetsBindingObserver {
  bool _isLoading = false;
  bool _isInitialized = false;
  String? timeRemaining;
  int? seconds;
  List<int?> pins = [null, null, null, null, null, null];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? room;
  String? token;
  IO.Socket? socket;

  void connectToRoomAndListen(StateSetter setState) {
    final socketURL = dotenv.env['SERVER_LINK']!;

    socket = IO.io(
      socketURL,
      IO.OptionBuilder().setTransports(['websocket']).build(),
    );
    socket!.connect();

    socket!.on(room!, (data) {
      setState(() {
        seconds = int.parse(extractNumericPart(data['timeLeft'].toString()));
        timeRemaining = secondsToMinutes(seconds!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);

    return LongBottomSheet(
      title: AppLocalizations.of(context)!.restorePasswordTitle,
      buttonChild: Text(AppLocalizations.of(context)!.sendLink),
      onSubmit: () async {
        room = await tryRecoverPassword(widget.emailController.text, context);
        Navigator.pop(context);
        _buildCodeScreen(context, UniqueKey());
      },
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.restorePasswordBody,
          style: getBottomSheetBodyStyle(isTablet),
          textAlign: TextAlign.justify,
        ),
        CustomFormField(
          keyboardType: TextInputType.emailAddress,
          controller: widget.emailController,
          labelText: AppLocalizations.of(context)!.emailText,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '';
            }
            return null;
          },
        ),
      ],
    );
  }

  Future<dynamic> _buildCodeScreen(BuildContext context, Key key) {
    bool isTablet = Responsive.isTablet(context);

    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            if (!_isInitialized) {
              _isInitialized = true;
              if (socket != null && socket!.connected && _isInitialized) {
                socket!.disconnect();
              } else {
                connectToRoomAndListen(setState);
              }
            }

            return FractionallySizedBox(
              heightFactor: 0.9,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Scaffold(
                  body: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 37 : 24.sp),
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: <Widget>[
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.close),
                                padding: EdgeInsets.zero,
                                alignment: Alignment.centerLeft,
                                iconSize: isTablet ? 26 : 20.sp,
                              ),
                              Center(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .verificationCode,
                                  style: getBottomSheetTitleStyle(isTablet),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 0),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 37 : 24.sp),
                          child: buildCodeForm(
                            isTablet,
                            true,
                            context,
                            _formKey,
                            widget.emailController.text,
                            (index) => PinInputField(
                              isTablet: isTablet,
                              onChanged: (value) {
                                if (value.length == 1 && index != 5) {
                                  FocusScope.of(context).nextFocus();
                                }

                                setState(() {
                                  pins[index] = int.tryParse(value);
                                });
                              },
                            ),
                            timeRemaining,
                            (seconds == null || seconds! > 0)
                                ? null
                                : () async {
                                    Navigator.pop(context);
                                    room = await tryRecoverPassword(
                                        widget.emailController.text, context);
                                    _buildCodeScreen(context, UniqueKey());
                                  },
                            (pins.any((element) => element == null))
                                ? null
                                : () async {
                                    _isLoading = true;
                                    _formKey.currentState!.save();
                                    var pinsString = pins.join('');
                                    int pin = int.parse(pinsString);
                                    token = await recoverWithCode(
                                        pin, room!, context);
                                    _buildSecondRestorePasswordModal(
                                        context, isTablet, token);
                                    _isLoading = false;
                                  },
                            _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        color: Colors.white),
                                  )
                                : Text(AppLocalizations.of(context)!.confirm),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }

  void _buildSecondRestorePasswordModal(
      BuildContext context, bool isTablet, String? token) {
    final TextEditingController passwordController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (context) {
        return LongBottomSheet(
          title: AppLocalizations.of(context)!.restorePasswordTitle,
          buttonChild: Text(AppLocalizations.of(context)!.update),
          onSubmit: () async {
            await UserService.updateCredentialsRecoveryAccount(
                token!, passwordController.text);
          },
          children: <Widget>[
            Text(
              AppLocalizations.of(context)!.secondRestorePasswordBody,
              style: getBottomSheetBodyStyle(isTablet),
              textAlign: TextAlign.justify,
            ),
            CustomFormField(
              controller: passwordController,
              labelText: AppLocalizations.of(context)!.password,
              keyboardType: TextInputType.visiblePassword,
              isPasswordField: true,
              validator: (value) {
                return validatePassword(value, context);
              },
            ),
            CustomFormField(
              labelText: AppLocalizations.of(context)!.confirmPassword,
              keyboardType: TextInputType.visiblePassword,
              isPasswordField: true,
              validator: (value) {
                return validatePasswordConfirmation(
                    value, passwordController, context);
              },
            ),
          ],
        );
      },
    );
  }
}
