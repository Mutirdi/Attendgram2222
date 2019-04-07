
var eventIndex;
var pageIndex;
//var QRflag ;
var currentLocation = <String, double>{};
var currentUserName;
var currentUserDescripition;
var globalUserId;
var currentUserinterests;
var currentUserPEvents;
var UserEmail;
var Event_Admin;
var currentEventAdmin ;
var currentEventIDs ;
var id;
var imageUrl;
var eventName,  eventAccessability;
DateTime eventStartingDate, eventFinishingDate, eventStartingTime, eventFinishingTime;
var occurrences ;
var occurr;
var lat;
var lon;


int i;

class eventData{
  var EventName, StartingDate, FinishingDate, StartingTime,
      FinishingTime, Accessability, Occur, AdminID, EventID,LocationName, lat, lon;

  eventData(this.EventName, this.StartingDate, this.FinishingDate,
      this.StartingTime, this.FinishingTime, this.Accessability, this.AdminID,this.LocationName, this.Occur, this.EventID, this.lat, this.lon);

}

List<eventData> userEvents;

