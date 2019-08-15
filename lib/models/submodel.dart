  

class SubObj {
  int id;

  String message,topic;

  SubObj({this.id,this.topic,this.message});

   Map<String, dynamic> toMap() {
    return {
      'id':id,
      'topic':topic,
      'message': message,
     
    };
  }


  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'SubObj{topic: $topic, message: $message}';
  }


}
