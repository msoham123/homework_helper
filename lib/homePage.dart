import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:hive/hive.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

bool isDarkMode = true;
var box = Hive.box('data');

bool loading = true;

class HomePageState extends State<HomePage>{

  ScrollController controller = ScrollController();
  List<ClassCard> list = [];
  List<DateTime> dates = [];
  int index = 0;
  DateTime temp;
  TextEditingController name = TextEditingController(), homework = TextEditingController();

  void initState(){
    super.initState();
    getCards();
  }

  void dispose(){
    super.dispose();
    controller.dispose();
    homework.dispose();
    name.dispose();
  }

  void getCards() async{
    // box.add("AP Calc BC:::;;;::::::;;;:::2020-10-11 17:05:35.340526");
    for(int i = 0; i<box.length;i++){
      List<String> temp = box.getAt(i).toString().split(":::;;;:::");
      list.add(
          ClassCard(
            name: temp[0],
            assignment: temp[1],
            dueDate: DateTime.parse(temp[2]),
            i: i,
          )
      );
      dates.add(DateTime.parse(temp[2]));
    }
    setState(() {
      loading = false;
    });
  }



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[200],
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[900] : Colors.blue,
                ),
                child: TabBar(
                  indicatorWeight: 6,
                  indicatorColor: isDarkMode ? Colors.blue : Colors.white,
                  onTap: (val){
                    setState(() {
                      index = val;
                    });
                  },
                  tabs: [
                    Tab(
                        icon: Icon(
                          Icons.folder_rounded,
                          color: isDarkMode ? Colors.blue : Colors.white ,
                        ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.calendar_today,
                        color: isDarkMode ? Colors.blue : Colors.white ,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  CupertinoScrollbar(
                    isAlwaysShown: true,
                    controller: controller,
                    child: ListView(
                      controller: controller,
                      children: loading ? [
                        SizedBox(height: MediaQuery.of(context).size.height/5,),
                        Center(
                          child: CircularProgressIndicator(),
                        )
                      ] : list,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width/40),
                    child: SfCalendar(
                      blackoutDatesTextStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black),
                      todayTextStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black),
                      cellBorderColor: isDarkMode ? Colors.blue : Colors.black,
                      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[200],
                      view: CalendarView.month,
                      monthViewSettings: MonthViewSettings(showAgenda: true),
                      headerStyle: CalendarHeaderStyle(backgroundColor: isDarkMode ? Colors.grey[900]: Colors.grey[200]),
                      appointmentTextStyle: TextStyle(color: isDarkMode ? Colors.blue : Colors.black),
                      viewHeaderStyle: ViewHeaderStyle(backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[200]),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width/72),
                    child: FloatingActionButton(
                      tooltip: isDarkMode ? "Light Mode" : "Dark Mode",
                      child: isDarkMode ? Icon(Icons.wb_sunny_sharp) : Icon(Icons.nights_stay_sharp) ,
                      onPressed: (){
                        setState(() {
                          isDarkMode = !isDarkMode;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width/72),
                    child: FloatingActionButton(
                      tooltip: "Add Class",
                      child: Icon(Icons.add_sharp),
                      onPressed: (){
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return GestureDetector(
                                onTap: (){
                                  FocusScopeNode currentFocus = FocusScope.of(context);
                                  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                                    FocusManager.instance.primaryFocus.unfocus();
                                  }
                                },
                                child: AlertDialog(
                                  backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                                  title: Center(
                                    child: Text(
                                      "Add Class",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: isDarkMode ? Colors.white54 : Colors.black,
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                  content: Container(
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView(
                                      children: [
                                        SizedBox(height: MediaQuery.of(context).size.height/60,),
                                        Center(
                                          child: Text(
                                            "Class Name",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: isDarkMode ? Colors.white54 : Colors.black,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: TextField(
                                            controller: name,
                                          ),
                                        ),
                                        SizedBox(height: MediaQuery.of(context).size.height/60,),
                                        Center(
                                          child: Text(
                                            "Homework (Optional)",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: isDarkMode ? Colors.white54 : Colors.black,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: TextField(
                                            controller: homework,
                                          ),
                                        ),
                                        SizedBox(height: MediaQuery.of(context).size.height/60,),
                                        Center(
                                          child: Text(
                                            "Due Date (Optional)",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: isDarkMode ? Colors.white54 : Colors.black,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: SfDateRangePicker(
                                            initialDisplayDate: DateTime.now(),
                                            onSelectionChanged: (DateRangePickerSelectionChangedArgs args){
                                              temp = args.value;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    FlatButton(
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },
                                      textColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                      ),
                                      child: Text("Close",
                                          style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15)),
                                    ),
                                    FlatButton(
                                      onPressed: (){
                                        if(name.value.text.isNotEmpty && name.value.text!=null){
                                          ClassCard card = ClassCard(
                                              name: name.value.text ,
                                              assignment: homework.value.text!= null ? homework.value.text : "",
                                              dueDate: temp!=null ? temp : DateTime.now(),
                                              i: box.length,
                                          );
                                          box.add(card.encode());
                                          setState(() {
                                            list.add(card);
                                          });
                                          Navigator.pop(context);
                                        }
                                      },
                                      textColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                      ),
                                      child: Text("Add",
                                          style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15)),
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class ClassCard extends StatefulWidget{

  final String name, assignment;
  final DateTime dueDate;
  final int i;

  String encode(){
    return "${name.replaceAll(":::;;;:::", "")}:::;;;:::${assignment.replaceAll(":::;;;:::", "")}:::;;;:::${dueDate.toString()}";
  }

  ClassCard({
    @required this.name,
    @required this.assignment,
    @required this.dueDate,
    @required this.i,
  });

  @override
  State<StatefulWidget> createState() {
    return ClassCardState();
  }
}

class ClassCardState extends State<ClassCard> {

  bool isHover = false, isEdit = false, isEditing = false, showDate = false;
  TextEditingController textController;
  DateTime due;

  void initState(){
    super.initState();
    textController = TextEditingController(text: widget.assignment);
    due = widget.dueDate;
  }

  void dispose(){
    super.dispose();
    textController.dispose();
  }

  String encode(){
    return "${widget.name}:::;;;:::${textController.value.text.replaceAll(":::;;;:::", "")}:::;;;:::${due.toString()}";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width/100),
      child: AnimatedPadding(
        padding: isHover && !isEdit ? EdgeInsets.only(bottom: 10) : EdgeInsets.only(top: 10),
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOutCirc,
        child: Container(
          // height: MediaQuery.of(context).size.height/7.5,
          width: MediaQuery.of(context).size.width/1.5,
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[800] : Colors.white70,
            borderRadius: BorderRadius.circular(12)
          ),
          child: InkWell(
            onHover: (value){
              setState(() {
                isHover = value;
              });
            },
            onTap: (){
              // FocusScopeNode currentFocus = FocusScope.of(context);
              // if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
              //   FocusManager.instance.primaryFocus.unfocus();
              // }
            },
            hoverColor: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: <Widget>[
                    SizedBox(width: MediaQuery.of(context).size.width/70,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isDarkMode ? Colors.white54 : Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if(isEdit) Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)
                                  ),
                                  padding: EdgeInsets.all(15),
                                  color: Colors.red,
                                  hoverColor: Colors.blue,
                                  onPressed: (){
                                    // print(widget.i);
                                    // print(list.length);
                                    // print(box.length);
                                    // setState(() {
                                    //   box.deleteAt(widget.i);
                                    //   list.removeAt(widget.i);
                                    // });
                                    box.deleteAt(widget.i);
                                    // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> MyApp()), (route) => false);
                                    Phoenix.rebirth(context);
                                  },
                                  child: Icon(Icons.delete)
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width/100,),
                              FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)
                                ),
                                hoverColor: Colors.blue,
                                onPressed: (){
                                  box.putAt(widget.i, encode());
                                  setState(() {
                                    isEdit = !isEdit;
                                  });
                                },
                                padding: EdgeInsets.all(15),
                                color: Colors.green,
                                child: Icon(Icons.check_sharp)
                              ),
                            ],
                          ),
                        ),
                        if(isHover && !isEdit) Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)
                            ),
                            padding: EdgeInsets.all(15),
                            color: Colors.green,
                            onPressed: (){
                              setState(() {
                                isEdit = !isEdit;
                              });
                            },
                            hoverColor: Colors.blue,
                            child: Icon(Icons.edit_sharp)
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width/70,),
                    Container(
                      color: isDarkMode ? Colors.blue : Colors.black,
                      height: MediaQuery.of(context).size.height/9,
                      width: 5,
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width/70,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height/60,),
                        Text(
                          "Homework",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isDarkMode ? Colors.white54 : Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width/2,
                          height: MediaQuery.of(context).size.height/9,
                          child: isEdit ? Center(
                            child: TextField(
                              controller: textController,
                            ),
                          ) : Center(
                            child: Text(
                              textController.value.text,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isDarkMode ? Colors.white54 : Colors.black,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width/70,),
                    Container(
                      color: isDarkMode ? Colors.blue : Colors.black,
                      height: MediaQuery.of(context).size.height/9,
                      width: 5,
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width/70,),
                    isEdit ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Due Date:\n" + due.toString().split(" ")[0],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isDarkMode ? Colors.white54 : Colors.black,
                            fontSize: 18.0,
                          ),
                        ),
                        if(!showDate) Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)
                            ),
                            padding: EdgeInsets.all(15),
                            color: Colors.blue,
                            onPressed: (){
                              setState(() {
                                showDate = true;
                              });
                            },
                            child: Icon(Icons.calendar_today_sharp)
                          ),
                        ),
                      ],
                    ) : Text(
                      "Due Date:\n" + due.toString().split(" ")[0],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white54 : Colors.black,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
                if(showDate && isEdit) Container(
                    child: Column(
                      children: [
                        SfDateRangePicker(
                          initialDisplayDate: due,
                          onSelectionChanged: (DateRangePickerSelectionChangedArgs args){
                            setState(() {
                              due = args.value;
                            });
                          },
                        ),
                        Center(
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)
                            ),
                            padding: EdgeInsets.all(15),
                            color: Colors.blue,
                            onPressed: (){
                              setState(() {
                                showDate = false;
                              });
                            },
                            child: Text(
                              "Close",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isDarkMode ? Colors.white54 : Colors.black,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height/60,),
                      ],
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

