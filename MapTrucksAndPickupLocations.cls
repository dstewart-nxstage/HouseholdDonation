global with sharing class MapTrucksAndPickupLocations {

   public Truck__c truck {get; set;}

   @RemoteAction
   global static List<Truck__c> getNearbyTruck(String lat, String lon) {

        if(lat == null || lon == null || lat.equals('') || lon.equals('')) {
            lat = '51.096214';
            lon = '3.683153';
        }

        String queryString =
            'SELECT Id, Name, Location__Longitude__s, Location__Latitude__s, ' +
                'Email__c, Status__c, Phone__c ' +
            'FROM Truck__c ' +
            //'WHERE DISTANCE(Location__c, GEOLOCATION('+lat+','+lon+'), \'km\') < 60 ' +
            //'ORDER BY DISTANCE(Location__c, GEOLOCATION('+lat+','+lon+'), \'km\') ' +
            'LIMIT 10';
        return(database.Query(queryString));
    }
}