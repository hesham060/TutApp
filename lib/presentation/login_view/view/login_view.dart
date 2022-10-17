import 'package:firstproject/presentation/resources/color_manager.dart';
import 'package:firstproject/presentation/resources/string_manager.dart';
import 'package:flutter/material.dart';
import '../../../app/di.dart';
import '../../resources/assets_manager.dart';
import '../../resources/routes_manager.dart';
import '../../resources/values_manager.dart';
import '../viewmodel/login_view_model.dart';


class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // here we use dependency injection
  final LoginViewModel _ViewModel = instance<LoginViewModel>();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _userPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _bind() {
    // here we start
    _ViewModel.start();
    _userNameController
        .addListener(() => _ViewModel.setUserName(_userNameController.text));

    _userPasswordController.addListener(
        () => _ViewModel.setPassword(_userPasswordController.text));
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _getContentWidget();
  }

  Widget _getContentWidget() {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: Container(
        padding: const EdgeInsets.only(top: AppPadding.p100),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Center(
                  child: Image(
                    image: AssetImage(
                      ImageManager.splashLogo,
                    ),
                  ),
                ),
                const SizedBox(
                  height: AppSize.s28,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: AppSize.s28, right: AppSize.s28),
                  child: StreamBuilder<bool>(
                    stream: _ViewModel.outIsUserNameValid,
                    builder: (context, snapshot) {
                      return TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _userNameController,
                        decoration: InputDecoration(
                          hintText: AppString.userNameError,
                          labelText: AppString.userNameError,
                          errorText: (snapshot.data ?? true)
                              ? null
                              : AppString.userNameError,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: AppSize.s28,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: AppSize.s28, right: AppSize.s28),
                  child: StreamBuilder<bool>(
                    stream: _ViewModel.outIsPasswordValid,
                    builder: (context, snapshot) {
                      return TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        controller: _userPasswordController,
                        decoration: InputDecoration(
                          hintText: AppString.passwordError,
                          labelText: AppString.passwordError,
                          errorText: (snapshot.data ?? true)
                              ? null
                              : AppString.passwordError,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: AppSize.s28,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: AppSize.s28, right: AppSize.s28),
                  child: StreamBuilder<bool>(
                      stream: _ViewModel.outAreAllInputsValid,
                      builder: (context, snapshot) {
                        return SizedBox(
                          width: double.infinity,
                          height: AppSize.s40,
                          child: ElevatedButton(
                            onPressed: (snapshot.data ?? false)
                                ? () {
                                    _ViewModel.login();
                                  }
                                : null,
                            child: const Text(AppString.login),
                          ),
                        );
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: AppPadding.p8,
                      left: AppPadding.p20,
                      right: AppPadding.p20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, Routes.forgetPasswordRoute);
                        },
                        child: Text(
                          AppString.forgetPassword,
                          textAlign: TextAlign.end,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, Routes.registerRoute);
                        },
                        child: Text(
                          AppString.registerText,
                          textAlign: TextAlign.end,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ViewModel.dispose();
    super.dispose();
  }
}
