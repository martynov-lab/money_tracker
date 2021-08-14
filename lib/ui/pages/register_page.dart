import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/bloc/register_bloc/register_bloc.dart';
import 'package:money_tracker/repository/user_repository.dart';
import 'package:money_tracker/ui/pages/login_page.dart';
import 'package:money_tracker/ui/widgets/register_form.dart';

class RegistrationPage extends StatelessWidget {
  final UserRepository _userRepository;

  const RegistrationPage({Key? key, required UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<RegisterBloc>(
        create: (context) => RegisterBloc(userRepository: _userRepository),
        child: Container(
          // height: double.infinity,
          // decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   colors: [Color(0xfff2cbd0), Color(0xfff4ced9)],
          // )),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 80),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Image.asset('assets/images/logo.png'),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 20),
                        child: Text(
                          'Учёт расходов',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        width: 250,
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          'Ваша история расходов всегда под рукой',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                RegisterForm(),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: Text(
                          'Уже есть аккаунт?',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      GestureDetector(
                        child: Text(
                          'Вход',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(144, 83, 235, 1),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return LoginPage(userRepository: _userRepository);
                            }),
                          );
                        },
                      )
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
}