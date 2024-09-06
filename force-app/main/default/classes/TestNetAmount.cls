/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-14-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

@isTest
private class TestNetAmount {
    @isTest
    static void testOrderNetAmount() {
        //Création des données
        Account testAccount = TestDataFactory.createAccount('Account 1');
        Product2 testProduct = TestDataFactory.createProduct2('Produit 1');
        PricebookEntry testPriceBookEntry = TestDataFactory.createPricebookEntry(testProduct.Id);   
        Order testOrder = TestDataFactory.createOrder(testAccount.Id);
        OrderItem testOrderItem1 = TestDataFactory.createOrderItem(testOrder.Id, testPriceBookEntry.Id, 10, 150);
        OrderItem testOrderItem = TestDataFactory.createOrderItem(testOrder.Id, testPriceBookEntry.Id, 10, 150);

        // Ajouter ShipmentCost__c pour calculer NetAmount__c
        testOrder.ShipmentCost__c = 50;
        update testOrder;

        Test.startTest();
        testOrder.Status = 'Ordered';
        update testOrder;
        Test.stopTest();

        
        //Vérifier le calcul de NetAmount__c
        Order updatedOrder = [SELECT Id, NetAmount__c, TotalAmount, ShipmentCost__c FROM Order WHERE Id = :testOrder.Id];
        Decimal expectedNetAmount = updatedOrder.TotalAmount - updatedOrder.ShipmentCost__c;
        System.assertEquals(expectedNetAmount, updatedOrder.NetAmount__c, 'Le NetAmount est mis à jour.');

        // ShipmentCost__c est null
        testOrder.ShipmentCost__c = null;
        update testOrder;
        Order updatedOrderWithoutShipmentCost = [SELECT Id, NetAmount__c, TotalAmount FROM Order WHERE Id = :testOrder.Id];
        System.assertEquals(updatedOrderWithoutShipmentCost.TotalAmount, updatedOrderWithoutShipmentCost.NetAmount__c, 'NetAmount should equal TotalAmount when ShipmentCost__c is null.');

    }
    @isTest
    static void testCalculateNetAmountWithNullList() {
    Test.startTest();
    // Appel de la méthode avec une liste nulle
    OrderNetAmountService.calculateNetAmount(null);
    Test.stopTest();
    System.debug('Le test passe avec une liste null');
}

}