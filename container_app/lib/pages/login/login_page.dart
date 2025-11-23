import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resources_package/l10n/app_localizations.dart';
import 'package:resources_package/resources/styles/styles.dart';
import 'package:ui_components_package/common_componenets/Buttons/language_button_standalone/language_button_stand_alone.dart';
import 'package:ui_components_package/common_componenets/aryan_logo.dart'
    as dir;
import 'package:ui_components_package/mobile_components/Buttons/dynamic_button.dart';
import 'package:ui_components_package/mobile_components/Buttons/loading_button.dart';
import 'package:ui_components_package/mobile_components/Inputs/verification.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../elements/html_text_parser.dart';
import '../launcher_page.dart';
import 'login_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(networkMode: 1),
      child: const LoginPageBody(),
    );
  }
}

class LoginPageBody extends StatefulWidget {
  const LoginPageBody({super.key});

  @override
  State<LoginPageBody> createState() => _LoginPageBodyState();
}

class _LoginPageBodyState extends State<LoginPageBody> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _passformKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passRecformKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _userformKey = GlobalKey<FormState>();

  String get _validationMsg =>
      AppLocalizations.of(context)?.passwordValidationMsg ?? '';

  String get _validationNullMsg =>
      AppLocalizations.of(context)?.passwordValidationNullMsg ?? '';

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _passwordFieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return _validationNullMsg;
    }
    if (value.length < 6) {
      return _validationMsg;
    }
    return null;
  }

  String? _usernameFieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return _validationNullMsg;
    }
    if (value.length < 3) {
      return _validationMsg;
    }
    return null;
  }

  Widget _buildPasswordTitle(BuildContext context) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.password),
      horizontalTitleGap: 20,
    );
  }

  Widget _buildUsernameTitle(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListTile(
        title: Text(
          AppLocalizations.of(context)!.phoneNumber,
          textAlign: TextAlign.right,
        ),
        leadingAndTrailingTextStyle: AryanText.secondary(),
        horizontalTitleGap: 20,
      ),
    );
  }

  Widget _buildUsernameBody(String username, BuildContext context) {
    _usernameController.text = username;
    return Form(
      key: _userformKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildUsernameTitle(context),
          AryanText.secondaryUsernameTextForm(
            controller: _usernameController,
            hintText: AppLocalizations.of(context)!.phoneNumber,
            obscureText: false,
            validator: _usernameFieldValidator,
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordBody(LoginPasswordState state, BuildContext context) {
    return Form(
      key: _passformKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildPasswordTitle(context),
          AryanText.secondaryPasswordTextFormWithToggle(
            controller: _passwordController,
            hintText: AppLocalizations.of(context)!.password,
            validator: _passwordFieldValidator,
          ),
          TextButton(
            onPressed: () {
              final bloc = context.read<LoginBloc>();
              bloc.add(LoginRecoveryPasswordEvent(_usernameController.text));
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                AppLocalizations.of(context)!.passwordForgot,
                style: AryanText.secondary(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecoverPasswordBody(
    LoginRecoverPasswordState state,
    BuildContext context,
  ) {
    return Form(
      key: _passRecformKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildPasswordTitle(context),
          AryanText.secondaryPasswordTextFormWithToggle(
            controller: _passwordController,
            hintText: AppLocalizations.of(context)!.passwordRecovery,
            validator: _passwordFieldValidator,
          ),
          const Divider(height: 20, color: Colors.transparent),
          ListTile(
            title: Text(AppLocalizations.of(context)!.passwordRecovery),
            horizontalTitleGap: 20,
            leading: const Icon(Icons.lock, color: Colors.black),
          ),
          AryanText.secondaryPasswordTextFormWithToggle(
            controller: _passwordController,
            hintText: AppLocalizations.of(context)!.password,
            validator: _passwordFieldValidator,
          ),
        ],
      ),
    );
  }

  Widget _buildOtpPasswordBody(String? phonNumber) {
    return Form(
      key: _passRecformKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildPasswordTitle(context),
          AryanText.secondaryPasswordTextFormWithToggle(
            controller: _passwordController,
            hintText: AppLocalizations.of(context)!.passwordRecovery,
            validator: _passwordFieldValidator,
          ),
          const Divider(height: 20, color: Colors.transparent),
          ListTile(
            title: Text(AppLocalizations.of(context)!.passwordRecovery),
            horizontalTitleGap: 20,
            leading: const Icon(Icons.lock, color: Colors.black),
          ),
          AryanText.secondaryPasswordTextFormWithToggle(
            controller: _passwordController,
            hintText: AppLocalizations.of(context)!.password,
            validator: _passwordFieldValidator,
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpBody(LoginSignUpState state, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        HtmlTextParserWidget(
          text: AppLocalizations.of(context)!.userSignupLabel,
          textAlign: TextAlign.center,
          defaultStyle: AryanText.secondary(),
        ),
      ],
    );
  }

  Widget _buildLoadingState(LoginLoadingState state) {
    return Column(
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 20),
        Text(state.message, style: AryanText.secondary()),
      ],
    );
  }

  Widget _buildErrorState(LoginErrorState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              state.error,
              style: AryanText.primButtonTextStyle().copyWith(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, LoginStates state) {
    String buttonText = AppLocalizations.of(context)!.loginButtonText;
    bool isLoading = state is LoginLoadingState;

    if (state is LoginSignUpState) {
      buttonText = AppLocalizations.of(context)!.loginButtonSignUpText;
    } else if (state is LoginOtpValidationState) {
      buttonText = AppLocalizations.of(context)!.loginButtonOtpText;
    }

    return LoadingButton(
      text: AppLocalizations.of(context)!.loginButtonText,
      onPressed: () => _handleButtonPress(context, state),
    );
  }

  void _handleButtonPress(BuildContext context, LoginStates state) {
    final bloc = context.read<LoginBloc>();

    if (state is LoginInitialState || state is LoginUsernameState) {
      _handleUsernameSubmit(bloc);
    } else if (state is LoginPasswordState) {
      _handlePasswordSubmit(bloc, state);
    } else if (state is LoginSignUpState) {
      _handleSignUp();
    } else if (state is LoginOtpValidationState) {
      // Handle OTP validation
    } else if (state is LoginRecoverPasswordState) {
      // Handle password recovery
    }
  }

  void _handleUsernameSubmit(LoginBloc bloc) {
    if (_userformKey.currentState?.validate() ?? false) {
      final username = _usernameController.text;
      bloc.add(LoginUsernameEvent(username));
    }
  }

  void _handlePasswordSubmit(LoginBloc bloc, LoginPasswordState state) {
    if (_passformKey.currentState?.validate() ?? false) {
      final password = _passwordController.text;
      bloc.add(LoginPasswordEvent(state.username, password));
    }
  }

  Future<void> _handleSignUp() async {
    try {
      await openUrl("https://github.com/");
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening signup page: $e')),
        );
      }
    }
  }

  Future<void> openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Widget _buildContent(LoginStates state, BuildContext context) {
    Widget content;

    if (state is LoginLoadingState) {
      content = _buildLoadingState(state);
    } else if (state is LoginErrorState) {
      content = _buildErrorState(state);
    } else if (state is LoginUsernameState || state is LoginInitialState) {
      final username = state is LoginUsernameState ? state.username : '';
      content = _buildUsernameBody(username, context);
    } else if (state is LoginPasswordState) {
      content = _buildPasswordBody(state, context);
    } else if (state is LoginRecoverPasswordState) {
      content = _buildRecoverPasswordBody(state, context);
    } else if (state is LoginOtpValidationState) {
      content = VerificationWidget();
    } else if (state is LoginSignUpState) {
      content = _buildSignUpBody(state, context);
    } else {
      content = const SizedBox();
    }

    return content;
  }

  LoginEvents _getBackPressed(LoginStates currentState) {
    if (currentState is LoginPasswordState) {
      return LoginBackEvent(currentState);
    } else if (currentState is LoginRecoverPasswordState) {
      return LoginBackEvent(currentState);
    } else if (currentState is LoginSignUpState) {
      return LoginBackEvent(currentState);
    } else if (currentState is LoginOtpValidationState) {
      return LoginBackEvent(currentState);
    } else {
      return LoginInitialEvent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginStates>(
      listener: (context, state) {
        if (state is LoginSuccessState) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => LauncherPage()),
            (route) => false,
          );
        }

        if (state is LoginErrorState && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginStates>(
        builder: (context, state) {
          // _updateValidationMessages(context);

          return Scaffold(
            appBar: (state is LoginUsernameState || state is LoginInitialState)
                ? AppBar(
                    primary: true,
                    scrolledUnderElevation: 0.0,
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.white,
                    animateColor: false,
                    title: const LanguageButtonStandAlone(),
                  )
                : AppBar(
                    toolbarHeight: 50,
                    primary: true,
                    animateColor: false,
                    backgroundColor: Colors.white,
                    scrolledUnderElevation: 0.0,
                    leading: CustomDynamicButton(
                      icon: const Icon(Icons.arrow_back),
                      useDefaultAnimation: false,
                      onPressed: () =>
                          context.read<LoginBloc>().add(_getBackPressed(state)),
                    ),
                    actions: const [LanguageButtonStandAlone()],
                  ),
            body: _buildBody(state, context),
          );
        },
      ),
    );
  }

  Widget _buildBody(LoginStates state, BuildContext context) {
    return Center(
      heightFactor: 1.5,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SizedBox(
            child: Column(
              key: ValueKey(state.runtimeType),
              children: [
                const dir.AryanLogo(),
                const SizedBox(height: 20),
                _buildContent(state, context),
                if (state is! LoginLoadingState && state is! LoginErrorState)
                  const SizedBox(height: 50),
                if (state is! LoginLoadingState && state is! LoginErrorState)
                  _buildLoginButton(context, state),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
