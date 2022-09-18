
import 'package:json_annotation/json_annotation.dart';
part 'responses.g.dart';




// here with baseresponse class no need constructor otherwise he will ask you things 

@JsonSerializable() // toApply from from json & tojson very easy
class BaseResponse {
  @JsonKey( name:"status") // we are use JsonKey when we need to change name of api variable with new name
  int? status; // because this value coming from api so we add ? sign
  @JsonKey(name: "message")
  String? message;
}


@JsonSerializable() 
class CustomerResponse {
  @JsonKey( name:"id") 
  int? id; 
  @JsonKey(name: "name")
  String? name;
 @JsonKey(name: "numOfNotifications")
  int ? numOfNotifications;
    CustomerResponse(this.id,this.name,this.numOfNotifications);

}

@JsonSerializable()
class ContactsResponse {
  @JsonKey( name:"phone") 
  String? phone; 
  @JsonKey(name: "email")
  String? email;
 @JsonKey(name: "link")
  String ? link;
  ContactsResponse(this.phone,this.email,this.link);
}


class AuthenticationResponse extends BaseResponse{
  @JsonKey( name:"customer") 
  CustomerResponse? customer; 
  @JsonKey(name: "contacts")
  ContactsResponse? contacts;
  AuthenticationResponse(this.customer, this.contacts);
  // from json

  // to json
  
}
