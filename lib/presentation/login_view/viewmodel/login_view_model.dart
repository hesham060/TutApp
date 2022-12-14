import 'dart:async';
import 'package:firstproject/domain/usecase/login_use_case.dart';
import 'package:firstproject/presentation/base/base_view_model.dart';
import '../../common/freezed_data_classes.dart';

// All this page only View Model
class LoginViewModel extends BaseViewModel
    with LoginViewModelInputs, LoginViewModelOutputs {
  // this Stream controller
  // broadcast means the stream has many listners
  final StreamController _userNamestreamController =
      StreamController<String>.broadcast();
  final StreamController _passwordstreamController =
      StreamController<String>.broadcast();
  // this variable coming from freezed package which save last information like user name and password
  var loginObject = LoginObject("", "");
  // here we make variable of Login usecase
  final LoginUseCase _loginUseCase;
  LoginViewModel(this._loginUseCase,);
  
  // this stream controller to active button if form is valid
  final StreamController _areAllInputsValidstreamController =
      StreamController<void>.broadcast();
  @override
  void dispose() {
    // here we are close in dispose function streams
    _userNamestreamController.close();
    _passwordstreamController.close();
  }

  @override
  void start() {}
  @override
  Sink get inputPassword => _passwordstreamController;
  @override
  Sink get inputUserName => _userNamestreamController;
  @override
  Sink get areAllInputsValid => _areAllInputsValidstreamController.sink;

  @override
  login() async {
    (await _loginUseCase.excute(
            LoginUseCaseInput(loginObject.userName, loginObject.password)))
        .fold(
      (failure) => {
        //left - failure
        print(failure.message)
      },
      (data) => {
        // right -> data (sucess)
        print(data.customer?.name)
      },
    );
  }

  @override
  Stream<bool> get outIsPasswordValid => _passwordstreamController.stream
      .map((password) => _isPasswordValid(password));

  @override
  Stream<bool> get outIsUserNameValid => _userNamestreamController.stream
      .map((userName) => _isPasswordValid(userName));

  @override
  Stream<bool> get outAreAllInputsValid =>
      _areAllInputsValidstreamController.stream
          .map((_) => _areAllInputsValid());

  @override
  setPassword(String password) {
    inputPassword.add(password);
    loginObject = loginObject.copyWith(password: password);
    // here checking data after user put his password by sink and stream controller normallay we start by null value
    areAllInputsValid.add(null);
  }

  @override
  setUserName(String username) {
    // here we inject  make sink and stream
    inputUserName.add(username);
    // here we inject to make save user and password memory and freezed
    loginObject = loginObject.copyWith(userName: username);
    areAllInputsValid.add(null);
  }

  // this function for change string input to bool outputs
  bool _isPasswordValid(String password) {
    return password.isNotEmpty;
  }
  // this function for change string input to bool outputs

  bool _isUserNameValid(String userName) {
    return userName.isNotEmpty;
  }

  // this function for checking password is valid and user name we use it in stream controller
  bool _areAllInputsValid() {
    return _isPasswordValid(loginObject.password) &&
        _isUserNameValid(loginObject.userName);
  }
}

abstract class LoginViewModelInputs {
  // here we are define what login page input and make variables
  setUserName(String username);
  setPassword(String password);
  login();
  Sink get inputUserName;
  Sink get inputPassword;
  Sink get areAllInputsValid;
}

abstract class LoginViewModelOutputs {
  Stream<bool> get outIsUserNameValid;
  Stream<bool> get outIsPasswordValid;
  Stream<void> get outAreAllInputsValid;
}
