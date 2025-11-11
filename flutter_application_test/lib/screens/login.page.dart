import 'dart:math';

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
   LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  bool passwordVisible = false;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // Simple email regex
    final pattern =
        r'^[^@]+@[^@]+\.[^@]+';
    final regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Login page',
          style: TextStyle(
            color: Colors.white,
            fontSize: 40
          )),
        backgroundColor: const Color.fromARGB(255, 153, 34, 34),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                "images/logo.jpg",
                height: 200,
                width: 120,
              ),
              SizedBox(height: 20,),
              Text(
                "Dima Wydad !",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 30,
                  fontWeight: FontWeight.w500
              ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.redAccent,

                  ),
                  
                ),
                keyboardType: TextInputType.emailAddress,
                validator: validateEmail,
              ),
               SizedBox(height: 20,),

              TextFormField(
                obscureText: !passwordVisible,
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  prefixIcon: Icon(
                    Icons.password,
                    color: Colors.redAccent,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                         passwordVisible = !passwordVisible;
                      });
                     
                    },
                    icon: Icon(
                      passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.redAccent,
                    ),
                    
                  ),
                  
                ),
                keyboardType: TextInputType.visiblePassword,
                validator: validatePassword,
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: (){
                  if (formkey.currentState!.validate()) {
                    ScaffoldMessenger.of( context).showSnackBar(
                      SnackBar(content: Text('Processing Data')),
                     
                    );
                     Navigator.pushNamed(context, '/home');
                    // Process data.
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                   
                  ),
                   backgroundColor: Colors.grey,
                ),
                child: Text(
                  'Login',
                  style: TextStyle(
                    color:Colors.red,
                    fontSize: 30),),
                
                ),
                SizedBox(height: 10,),
                TextButton(
                  onPressed: (){
                    Navigator.pushNamed(context, '/register');
                  }, 
                  child: Text(
                    'Don\'t have an account? Register',
                    style: TextStyle()))
            ],
            
          )
          ),),
    );
  }
}