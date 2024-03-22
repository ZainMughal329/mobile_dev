import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lesedi/utils/app_color.dart';
import 'package:lesedi/auth/reset_password_view/notifier/reset_password_notifier.dart';
import 'package:flutter/material.dart';
import 'package:lesedi/utils/constants.dart';
import 'package:lesedi/widgets/common_widgets/input_field_widget.dart';
import '../../login/view/login_view.dart';

class ResetPassword extends ConsumerWidget {
  ResetPassword({super.key});

  final resetPasswordProvider =
      ChangeNotifierProvider<ResetPasswordNotifier>((ref) {
    return ResetPasswordNotifier();
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(resetPasswordProvider);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage("assets/images/Login.png"),
              fit: BoxFit.cover,
            )),
        child: Container(
          child: Container(
            /// Set gradient black in image splash screen (Click to open code)
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                  Color.fromRGBO(0, 0, 0, 0),
                  Color.fromRGBO(0, 0, 0, 0)
                ],
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter)),
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 80.0),
                      ),
                      Container(
                        child: Image.asset(
                          MyConstants.myConst.appLogo,
                          width: 150,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 40.0),
                      ),
                      Text(
                        'Reset Password'.toUpperCase(),
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 22,
                          color: AppColors.PRIMARY_COLOR,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      InputFieldWidget(
                          controller: notifier.tokenNumberController,
                          textInputType: TextInputType.number,
                          label: 'Token Number'),
                      InputFieldWidget(
                        controller: notifier.passwordController,
                        label: 'Password',
                        textInputType: TextInputType.visiblePassword,
                        isObscure: notifier.isSecure,
                        hasSuffix: true,
                        suffixIcon: InkWell(
                          onTap: () {
                            notifier.setSecure();
                          },
                          child: Icon(
                            Icons.remove_red_eye,
                            size: 18.0,
                            color: const Color(0xff626a76),
                          ),
                        ),
                      ),
                      InputFieldWidget(
                        controller: notifier.confirmPasswordController,
                        label: 'Reset Password',
                        isObscure: notifier.isResetSecure,
                        textInputType: TextInputType.visiblePassword,
                        hasSuffix: true,
                        suffixIcon: InkWell(
                          onTap: () {
                            notifier.setResetSecure();
                          },
                          child: Icon(
                            Icons.remove_red_eye,
                            size: 18.0,
                            color: const Color(0xff626a76),
                          ),
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            if (!notifier.isLoading) {
                              notifier.resetPasswordClicked(context: context);
                            }
                          },
                          child: notifier.isLoading
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      top: 30, right: 50, left: 50),
                                  child: Container(
                                    height: 50.0,
                                    padding: EdgeInsets.only(top: 0),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: AppColors.PRIMARY_COLOR,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0x1a000000),
                                          offset: Offset(0, 6),
                                          blurRadius: 12,
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      height: 25,
                                      width: 25,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            new AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      top: 30, right: 50, left: 50),
                                  child: Container(
                                    height: 50.0,
                                    padding: EdgeInsets.only(top: 4),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: AppColors.PRIMARY_COLOR,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0x1a000000),
                                          offset: Offset(0, 6),
                                          blurRadius: 12,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      'SUBMIT',
                                      style: TextStyle(
                                        fontFamily: 'Open Sans',
                                        fontSize: 16,
                                        color: const Color(0xffffffff),
                                        letterSpacing: 0.152,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                )),
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Container(
                          width: 150,
                          height: 2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: AppColors.PRIMARY_COLOR),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (!notifier.isLoading) {
                            Navigator.of(context).pushReplacement(
                                PageRouteBuilder(
                                    pageBuilder: (_, __, ___) => Login()));
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: Container(
                            child: Text.rich(
                              TextSpan(
                                style: TextStyle(
                                  fontFamily: 'Open Sans',
                                  fontSize: 14,
                                  color: const Color(0xff4d4d4d),
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Back to Login',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
