import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/utils/sign_utils.dart';
import 'package:vetplus/widgets/common/skeleton_screen.dart';

class AuthCodeScreen extends StatefulWidget {
  const AuthCodeScreen({
    super.key,
    required this.room,
    required this.name,
    required this.lastname,
    required this.email,
    required this.password,
  });
  final String room;
  final String name;
  final String lastname;
  final String email;
  final String password;

  @override
  State<AuthCodeScreen> createState() => _AuthCodeScreenState();
}

class _AuthCodeScreenState extends State<AuthCodeScreen>
    with WidgetsBindingObserver {
  String? timeRemaining;
  int? seconds;
  IO.Socket? socket;
  List<int?> pins = [null, null, null, null, null, null];
  bool _isInitialized = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String secondsToMinutes(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String extractNumericPart(String input) {
    RegExp regex = RegExp(r'\d+');
    Match? match = regex.firstMatch(input);
    if (match != null) {
      return match.group(0)!;
    } else {
      return '';
    }
  }

  void connectToRoomAndListen() {
    final socketURL = dotenv.env['SERVER_LINK']!;

    socket = IO.io(
      socketURL,
      IO.OptionBuilder().setTransports(['websocket']).build(),
    );
    socket!.connect();

    socket!.on(widget.room, (data) {
      if (mounted) {
        setState(() {
          seconds = int.parse(extractNumericPart(data['timeLeft'].toString()));
          timeRemaining = secondsToMinutes(seconds!);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (socket != null && socket!.connected && _isInitialized) {
      socket!.disconnect();
    } else {
      connectToRoomAndListen();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _isInitialized = true;
    } else if (state == AppLifecycleState.paused) {}
  }

  @override
  void didUpdateWidget(covariant AuthCodeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('UPDATE');
    if (widget.room != oldWidget.room) {
      _isInitialized = false;
      connectToRoomAndListen();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);

    return SkeletonScreen(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Wrap(
              runSpacing: isTablet ? 60 : 40.sp,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/vetplus-logo.png',
                      height: MediaQuery.of(context).size.height * 0.0774,
                    ),
                  ],
                ),
                Text(AppLocalizations.of(context)!.verificationCode,
                    style: getAppbarTitleStyle(isTablet)),
                RichText(
                  text: TextSpan(
                    style: getCarouselBodyStyle(isTablet),
                    children: <TextSpan>[
                      TextSpan(
                          text:
                              '${AppLocalizations.of(context)!.weSentCode}\n'),
                      TextSpan(
                        text: widget.email,
                        style: getCarouselBodyStyle(isTablet).copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    6,
                    (index) => PinInputField(
                      isTablet: isTablet,
                      onChanged: (value) {
                        if (value.length == 1 && index != 5) {
                          FocusScope.of(context).nextFocus();
                        }
                        print(value);
                        setState(() {
                          pins[index] = int.tryParse(value);
                        });
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: getCarouselBodyStyle(isTablet),
                        children: <TextSpan>[
                          TextSpan(
                              text: AppLocalizations.of(context)!.resendCode),
                          TextSpan(
                            text: timeRemaining,
                            style: getCarouselBodyStyle(isTablet).copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: (seconds == null || seconds! > 0)
                        ? null
                        : () async {
                            await trySignUpWithEmail(
                                widget.name,
                                widget.lastname,
                                widget.email,
                                widget.password,
                                context);
                          },
                    style: ElevatedButton.styleFrom(
                      foregroundColor:
                          Theme.of(context).colorScheme.onSurfaceVariant,
                      backgroundColor:
                          Theme.of(context).colorScheme.surfaceVariant,
                    ),
                    child: Text(AppLocalizations.of(context)!.resend),
                  ),
                ),
                SizedBox(
                  width: isTablet ? 60 : 20,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: (pins.any((element) => element == null))
                        ? null
                        : () async {
                            _formKey.currentState!.save();
                            var pinsString = pins.join('');
                            int pin = int.parse(pinsString);
                            await signUpWithCode(pin, widget.room, context);
                          },
                    child: Text(AppLocalizations.of(context)!.confirm),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PinInputField extends StatelessWidget {
  const PinInputField({
    super.key,
    required this.isTablet,
    required this.onChanged,
  });

  final bool isTablet;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isTablet ? 64 : 54.sp,
      width: isTablet ? 60 : 50.sp,
      child: TextFormField(
        onChanged: onChanged,
        decoration: const InputDecoration(hintText: '0'),
        style: Theme.of(context).textTheme.headlineMedium,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }
}
