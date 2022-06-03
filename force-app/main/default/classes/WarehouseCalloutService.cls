public with sharing class WarehouseCalloutService implements Queueable, Database.AllowsCallouts{

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';

    //public static HttpResponse
    
    public static void getConexionData(){
        System.debug('//////');
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-superbadge-apex.herokuapp.com/equipment');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        List<Product2> existentEquipmentList= [SELECT Replacement_Part__c, Cost__c, Current_Inventory__c, Lifespan_Months__c, Maintenance_Cycle__c, Warehouse_SKU__c FROM Product2];
        Map<String, Product2> existEquipmentMap = new Map<String,Product2>();
        List<Product2> newEquipmentList = new List<Product2>();
        for(Product2 existEquip: existentEquipmentList){
            existEquipmentMap.put(existEquip.Warehouse_SKU__c,existEquip);
        }
        if(response.getStatusCode() == 200){
            System.debug('Entro en el if');       
            List<Object> equipmentFromDataList = (List<Object>) JSON.deserializeUntyped(response.getBody());
            for(Object equip: equipmentFromDataList){
                Map<String,Object> equipmentData = (Map<String,Object>) equip;   
                Product2 newEquipment = new Product2();
                String name = (String) equipmentData.get('name');
                Integer cost =(Integer) equipmentData.get('cost');
                Integer inventory = (Integer) equipmentData.get('quantity');
                Integer lifespan = (Integer) equipmentData.get('lifespan');
                Integer maintenanceCycle = (Integer) equipmentData.get('maintenanceperiod');
                String sku = (String) equipmentData.get('_id');
                newEquipment.Name=name;
                //newEquipment.Replacement_Part__c=(Boolean)equipmentData.get('replacement');
                newEquipment.Replacement_Part__c=true;
                newEquipment.Cost__c=cost;
                newEquipment.Current_Inventory__c=inventory;
                newEquipment.Lifespan_Months__c=lifespan;
                newEquipment.Maintenance_Cycle__c=maintenanceCycle;
                newEquipment.Warehouse_SKU__c=sku;                
                if(existEquipmentMap.get(sku)!=null){                   
                    Product2 existEquiment = newEquipment.clone(false,false,false,false);
                    existEquiment.Id = existEquipmentMap.get(sku).Id;
                    newEquipmentList.add(existEquiment);
                }else{
                    newEquipmentList.add(newEquipment);
                }
                
            }
            if(newEquipmentList.size()>0){
                upsert newEquipmentList;
            }
            

        }

    }
    public static void execute (QueueableContext context){
        getConexionData();
    }
    
}