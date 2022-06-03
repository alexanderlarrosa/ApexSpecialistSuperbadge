@isTest
public with sharing class MaintenanceRequestHelperTest {
    @isTest static void testUpdateWorkOrders(){
        Case maintenanceRequest = new Case();
        List<Case> maintenanceList = new List<Case>();
        Equipment_Maintenance_Item__c equipmentItem = new Equipment_Maintenance_Item__c();
        Product2 equipment = new Product2();
        equipment.Name='Example new';
        equipment.Replacement_Part__c=true;
        equipment.Cost__c=1000;
        equipment.Current_Inventory__c=5;
        equipment.Lifespan_Months__c=2;
        equipment.Maintenance_Cycle__c=180;
        equipment.Warehouse_SKU__c='100009';
        insert equipment;
        //Product2 = [SELECT Replacement_Part__c,Cost__c,Current_Inventory__c,Lifespan_Months__c,Maintenance_Cycle__c,Warehouse_SKU__c FROM Product2 WHERE Id=:equipment.Id];
        maintenanceRequest.Status ='Closed';
        maintenanceRequest.Type = 'Routine Maintenance';
        insert maintenanceRequest;
        Case newMaintenanceRequest = [SELECT CaseNumber FROM Case WHERE Id=:maintenanceRequest.Id];
        equipmentItem.Maintenance_Request__c=newMaintenanceRequest.Id;
        insert equipmentItem;
        Equipment_Maintenance_Item__c newEquipmentIdem = [SELECT Maintenance_Request__r.CaseNumber FROM Equipment_Maintenance_Item__c WHERE Id=:equipmentItem.Id];
        newEquipmentIdem.Maintenance_Request__c=newMaintenanceRequest.Id;
        newEquipmentIdem.Equipment__c=equipment.Id;
        newMaintenanceRequest.Status=maintenanceRequest.Status;
        newMaintenanceRequest.Type=maintenanceRequest.Type;
        newMaintenanceRequest.Product__c=maintenanceRequest.Product__c;
        upsert newEquipmentIdem;
        maintenanceList.add(newMaintenanceRequest);
        MaintenanceRequestHelper.updateWorkOrders(maintenanceList);
        Equipment_Maintenance_Item__c finalItem = [SELECT Maintenance_Request__r.CaseNumber FROM Equipment_Maintenance_Item__c WHERE Id=:equipmentItem.Id];
        System.assertNotEquals(finalItem.Maintenance_Request__r.CaseNumber, newEquipmentIdem.Maintenance_Request__r.CaseNumber);
    }
    
    @isTest static void testUpdateWorkOrders2(){
        Case maintenanceRequest = new Case();
        List<Case> maintenanceList = new List<Case>();
        Equipment_Maintenance_Item__c equipmentItem = new Equipment_Maintenance_Item__c();
        Product2 equipment = new Product2();
        equipment.Name='Example new';
        equipment.Replacement_Part__c=true;
        equipment.Cost__c=1000;
        equipment.Current_Inventory__c=5;
        equipment.Lifespan_Months__c=2;
        equipment.Maintenance_Cycle__c=null;
        equipment.Warehouse_SKU__c='100009';
        insert equipment;
        maintenanceRequest.Status ='Closed';
        maintenanceRequest.Type = 'Routine Maintenance';
        insert maintenanceRequest;
        Case newMaintenanceRequest = [SELECT CaseNumber FROM Case WHERE Id=:maintenanceRequest.Id];
        equipmentItem.Maintenance_Request__c=newMaintenanceRequest.Id;
        insert equipmentItem;
        Equipment_Maintenance_Item__c newEquipmentIdem = [SELECT Maintenance_Request__r.CaseNumber FROM Equipment_Maintenance_Item__c WHERE Id=:equipmentItem.Id];
        newEquipmentIdem.Maintenance_Request__c=newMaintenanceRequest.Id;
        newEquipmentIdem.Equipment__c=equipment.Id;
        newMaintenanceRequest.Status=maintenanceRequest.Status;
        newMaintenanceRequest.Type=maintenanceRequest.Type;
        newMaintenanceRequest.Product__c=maintenanceRequest.Product__c;
        upsert newEquipmentIdem;
        maintenanceList.add(newMaintenanceRequest);
        MaintenanceRequestHelper.updateWorkOrders(maintenanceList);
        
    }
    


}