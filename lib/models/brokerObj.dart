
class BrokerObj {
  int id;
  String clientId,hostname,portNo,username,password;

  BrokerObj({this.id,this.clientId,this.hostname,this.portNo,this.username,this.password});

   Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clientId':clientId,
      'hostname': hostname,
      'portNo': portNo,
      'username':username,
      'password':password,
    };
  }


  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'BrokerObj{id: $id, clientId: $clientId, hostname: $hostname,portNo: $portNo,username: $username, password: $password}';
  }


}
