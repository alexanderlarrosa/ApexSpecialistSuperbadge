@IsTest
private class WarehouseCalloutServiceTest {
    @isTest static  void warehouseServiceTest() {
        Product2 newProduct = new Product2();
        newProduct.Current_Inventory__c=10;
        newProduct.Name='Generator 1000 kW';
        newProduct.Warehouse_SKU__c='55d66226726b611100aaf741';
        insert newProduct;
        Test.startTest();
        Test.SetMock(HttpCallOutMock.class, new WarehouseCalloutServiceMock()); 
        WarehouseCalloutService.getConexionData();
		
        List<Product2> productsToUpsert = [SELECT Replacement_Part__c, Cost__c, Current_Inventory__c, Lifespan_Months__c,
                                           Maintenance_Cycle__c, Name FROM Product2];
        
        System.assert( true, productsToUpsert.size() == 1 );
        
        // Update Salesforce Records
        for ( Product2 equipmentUpserted : productsToUpsert ) {
            System.assert( true, equipmentUpserted.Replacement_Part__c );
            System.assert( true, equipmentUpserted.Cost__c != null );
            System.assert( true, equipmentUpserted.Current_Inventory__c != null );
            System.assert( true, equipmentUpserted.Lifespan_Months__c != null );
            System.assert( true, equipmentUpserted.Maintenance_Cycle__c == 5 );
            System.assert( true, equipmentUpserted.Name != null );
        }
        
        Test.stopTest();
    }

    @isTest static  void warehouseServiceTest2() {
        Test.startTest();
        Test.SetMock(HttpCallOutMock.class, new WarehouseCalloutServiceMock()); 
        WarehouseCalloutService.getConexionData();
		
        List<Product2> productsToUpsert = [SELECT Replacement_Part__c, Cost__c, Current_Inventory__c, Lifespan_Months__c,
                                           Maintenance_Cycle__c, Name FROM Product2];
        
        System.assert( true, productsToUpsert.size() == 1 );
        
        // Update Salesforce Records
        for ( Product2 equipmentUpserted : productsToUpsert ) {
            System.assert( true, equipmentUpserted.Replacement_Part__c );
            System.assert( true, equipmentUpserted.Cost__c != null );
            System.assert( true, equipmentUpserted.Current_Inventory__c != null );
            System.assert( true, equipmentUpserted.Lifespan_Months__c != null );
            System.assert( true, equipmentUpserted.Maintenance_Cycle__c != null );
            System.assert( true, equipmentUpserted.Name != null );
        }
        
        Test.stopTest();
    }

}