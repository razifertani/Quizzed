import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:QuizzedGame/services/database.dart';
import 'package:QuizzedGame/views/create.dart';
import 'package:QuizzedGame/views/playQuiz.dart';
import 'package:QuizzedGame/widgets/widgets.dart';

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
        appBar: AppBar(
          title: appBar(context),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          brightness: Brightness.light,
        ),
        body: quizList(),
        bottomNavigationBar: ConvexAppBar(
          backgroundColor: Colors.blue,
          items: [
            TabItem(icon: Icons.people, title: 'Profile'),
            TabItem(icon: Icons.add, title: 'Add'),
            TabItem(icon: Icons.history, title: 'History'),
          ],
          initialActiveIndex: 1, //optional, default as 0
          onTap: (int i) {
            i == 2
                ? Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Create(),
                    ),
                  )
                : null;
          },
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
        height: MediaQuery.of(context).size.height * 0.26,
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(imageURL,
                  width: MediaQuery.of(context).size.width * 0.9,
                  fit: BoxFit.fitWidth),
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
