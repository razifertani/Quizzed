import 'package:QuizzedGame/views/signin.dart';
import 'package:flutter/material.dart';
import 'package:QuizzedGame/services/database.dart';
import 'package:QuizzedGame/views/create.dart';
import 'package:QuizzedGame/views/playQuiz.dart';
import 'package:QuizzedGame/widgets/widgets.dart';
import 'package:multilevel_drawer/multilevel_drawer.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream quizStream;
  DataBaseService dataBaseService = DataBaseService();

  Widget quizList() {
    return Container(
      child: StreamBuilder(
        stream: quizStream,
        builder: (context, snapchot) {
          return snapchot.data == null
              ? Container(
                  child: Center(
                    child: Text(
                      'No quizz !',
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: snapchot.data.documents.length,
                  itemBuilder: (context, index) {
                    return QuizTile(
                      quizId: snapchot.data.documents[index].data['quizzId'],
                      imageURL:
                          snapchot.data.documents[index].data['quizzImageUrl'],
                      title: snapchot.data.documents[index].data['quizzTitle'],
                      description: snapchot
                          .data.documents[index].data['quizzDescription'],
                    );
                  },
                );
        },
      ),
    );
  }

  @override
  void initState() {
    dataBaseService.getQuizData().then((value) {
      setState(() {
        quizStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MultiLevelDrawer(
            header: Container(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.1,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'Assets/pdp.jpg',
                      width: 120,
                      height: 120,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Text('Razi Fertani'),
                  ],
                ),
              ),
            ),
            children: [
              MLMenuItem(
                leading: Icon(Icons.person),
                trailing: Icon(Icons.arrow_right),
                content: Text('Profile'),
                onClick: () {},
              ),
              MLMenuItem(
                leading: Icon(Icons.settings),
                trailing: Icon(Icons.arrow_right),
                content: Text('Settings'),
                onClick: () {},
              ),
              MLMenuItem(
                leading: Icon(Icons.close),
                trailing: Icon(Icons.arrow_right),
                content: Text('Logout'),
                onClick: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignIn(),
                    ),
                  );
                },
              ),
            ]),
        appBar: AppBar(
          title: appBar(context),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          brightness: Brightness.light,
        ),
        body: quizList(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Create(),
              ),
            );
          },
        ),
        bottomNavigationBar: ConvexAppBar(
          items: [
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.map, title: 'Discovery'),
            TabItem(icon: Icons.add, title: 'Add'),
            TabItem(icon: Icons.message, title: 'Message'),
            TabItem(icon: Icons.people, title: 'Profile'),
          ],
          initialActiveIndex: 2, //optional, default as 0
          onTap: (int i) => print('click index=$i'),
        ));
  }
}

class QuizTile extends StatelessWidget {
  final String imageURL;
  final String title;
  final String description;
  final String quizId;

  const QuizTile({
    @required this.imageURL,
    @required this.title,
    @required this.description,
    @required this.quizId,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PlayQuiz(
              quizId: quizId,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical: MediaQuery.of(context).size.height * 0.01,
        ),
        height: MediaQuery.of(context).size.height * 0.3,
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageURL,
                width: MediaQuery.of(context).size.width * 0.9,
                fit: BoxFit.fitWidth,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black26,
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
