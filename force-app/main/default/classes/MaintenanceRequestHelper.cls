public with sharing class MaintenanceRequestHelper {
    
    
    
    //crear nueva rutina y actualizar los workorders
    public static void updateWorkOrders( List<Case> maintenanceRequests) {
        
        List<Case> newMaintenanceRequest = new List<Case>();
        List<Product2> equipmentList = [SELECT ProductCode, Maintenance_Cycle__c FROM Product2];
        List<Equipment_Maintenance_Item__c> equipmentItems = [SELECT Name,Maintenance_Request__c, Maintenance_Request__r.CaseNumber, Equipment__r.Maintenance_Cycle__c FROM Equipment_Maintenance_Item__c];
        Case newMaintance = new Case();
        for(Case mr: maintenanceRequests){
            System.debug(mr);
            System.debug('Status es '+mr.Status);
            if(mr.Status=='Closed'){
                if(mr.Type=='Repair' || mr.Type=='Routine Maintenance'){                    
                    newMaintance = mr.clone(false,false,false,false);
                    newMaintance.Type='Routine Maintenance';
                    newMaintance.Subject=mr.CaseNumber;
                    newMaintance.Status='New';
                    newMaintance.Product__c=mr.Product__c;
                    newMaintenanceRequest.add(newMaintance);
                }   
            }       
        }
        insert newMaintenanceRequest;


        for(Case nmr:newMaintenanceRequest){
            Decimal maintenanceCycle=10000;
            for(Equipment_Maintenance_Item__c item:equipmentItems){
                if(item.Maintenance_Request__r.CaseNumber==nmr.Subject){    
                    item.Maintenance_Request__c=nmr.Id;
                    if(item.Equipment__r.Maintenance_Cycle__c!=null && item.Equipment__r.Maintenance_Cycle__c<maintenanceCycle){
                        maintenanceCycle=item.Equipment__r.Maintenance_Cycle__c;                        
                        nmr.Date_Due__c=Date.today().addDays(Integer.valueOf(item.Equipment__r.Maintenance_Cycle__c));
                    }else{
                        nmr.Date_Due__c=Date.today();
                    }

                }
            }
        }
        update newMaintenanceRequest;
        update equipmentItems;

        
    }
    
    
    
    
    
    
    
}