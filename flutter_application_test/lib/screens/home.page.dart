import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Home Page",
        style: TextStyle(
          color: Colors.black54,
          fontSize: 40,
          fontWeight: FontWeight.w500
          ),
        ),
        backgroundColor: Colors.redAccent,
        ),
        body: Center(
          child:Text(
            textAlign: TextAlign.center,
            "Welcome to the Home Page!",
            style:TextStyle(
              color: Colors.black54,
              fontSize: 50
            )
          )
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blueGrey, Colors.redAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),


                  
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage("images/etudiant1.jpg"),
                      radius: 35,
                    ),
                    SizedBox(height: 10,),
                    Text("Othmane Lazrek",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.w500
                    ),),
                    Text(
                      "othmane@gmail.com",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic
                    ),),
                    
                  ],
                ),),
              ListTile(
                onTap:(){ Navigator.pop(context);},
                leading: Icon(
                  Icons.coronavirus_rounded,
                  color: Colors.green,),
                title: Text(
                  "Covid Tracker",
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 20,
                ),
                ),
              ),
              Divider(
                color: Colors.black54,
              ),
              ListTile(
                onTap:(){ Navigator.pop(context);},
                leading: Icon(
                  Icons.chat,
                  color: Colors.blueAccent,),
                title: Text(
                  "Emsi chatbot",
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 20,
                ),
                ),
              ),
              Divider(
                color: Colors.black54,
              ),
              ListTile(
                onTap:(){ Navigator.pop(context);},
                leading: Icon(
                  Icons.person,
                  color: Colors.teal,),
                title: Text(
                  "Profile",
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 20,
                ),
                ),
              ),
              Divider(
                color: Colors.black54,
              ),
              ListTile(
                onTap:(){ Navigator.pop(context);},
                leading: Icon(
                  Icons.settings,
                  color: Colors.grey,),
                title: Text(
                  "Settings",
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 20,
                ),
                ),
              ),
              Divider(
                color: Colors.black54,
              ),
              ListTile(
                onTap:(){ Navigator.pop(context);},
                leading: Icon(
                  Icons.logout,
                  color: Colors.redAccent,),
                title: Text(
                  "Log out",
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 20,
                ),
                ),
              ),
              Divider(
                color: Colors.black54,
              ),
            
            ],
            
          ),
        ),


        
        );
  }
}