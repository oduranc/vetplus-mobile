import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:vetplus/responsive/responsive_layout.dart';
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
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
      body: buildCodeForm(
        isTablet,
        false,
        context,
        _formKey,
        widget.email,
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
                await trySignUpWithEmail(widget.name, widget.lastname,
                    widget.email, widget.password, context);
              },
        (pins.any((element) => element == null))
            ? null
            : () async {
                _isLoading = true;
                _formKey.currentState!.save();
                var pinsString = pins.join('');
                int pin = int.parse(pinsString);
                await signUpWithCode(pin, widget.room, context);
                _isLoading = false;
              },
        _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white),
              )
            : Text(AppLocalizations.of(context)!.confirm),
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
