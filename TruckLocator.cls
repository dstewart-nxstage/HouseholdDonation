public class TruckLocator {
    
    // Questions: What is the truck's capacity?
    // How/when do we reassign trucks?
    static public void assignTrucks(List<Pickup__c> pickups) {
        
        pickups = getPickupDetails(pickups);
        Integer i = [Select count() from Truck__c];
        System.debug(i + ' trucks in the system');
        List<Truck__c> trucks = [Select Name, Location__c, Email__c, Status__c
                                 from   Truck__c
                                 where  Status__c = 'Available'];
        //System.debug('11. ' + trucks.size() + ' trucks found ');
        Map<Id, Truck__c> mapTrucksByPickupId = new Map<Id, Truck__c>();
        for(Pickup__c pickup : pickups) {
            Double distance;
            // calculate the distance
            // Select and access the Location field. MyLocation__c is the name of a geolocation field on Account.
            //Location loc = pickup.Location__c;
                for(Truck__c truck : trucks) {
                    //Location trLoc = truck.location__c;
                    Double currDist = Location.getDistance(pickup.Location__c, truck.Location__c, 'mi');
                    // If the newest calculated distance is less than the previous one (or we haven't calc'd it yet),
                    // post the relation to the map
                    if(distance == null || currDist < distance) {
                        mapTrucksByPickupId.put(pickup.Id, truck);
                        distance = currDist;
                    }
                }
                // The trucks have been identified - update the Pickup with the closest one
                Truck__c newTruck = mapTrucksByPickupId.get(pickup.Id);
                if(newTruck <> null) {
                        // we found a truck; we'll update this pickup
                    pickup.Truck__c = newTruck.Id;
                    pickup.Delivery_Driver_email__c = newTruck.Email__c;
                 }
        }
        Database.SaveResult[] updateResults = Database.update(pickups, false);
        for(Database.SaveResult result : updateResults) {
            if(!result.isSuccess()){
                System.debug('An error occurred updating Pickup ');
            }
        }
			
    }
    
    static public List<Pickup__c> getPickupDetails(List<Pickup__c> pickups) {
        Set<Id> setPickupIds = new Set<Id>();
        for(Pickup__c pickup : pickups){
            setPickupIds.add(pickup.Id);
        }
        List<Pickup__c> results = [Select Id, Name, Location__c, Truck__c
                                   from   Pickup__c
                                   where  Id in :setPickupIds
                                   and Truck__c = null];
        return results;
    }
    
}