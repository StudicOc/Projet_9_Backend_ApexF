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

        
        // Vérification de la BDD
        testOrderItem = [SELECT Id, OrderId FROM OrderItem WHERE Id = :testOrderItem.Id];
        System.assertNotEquals(null, testOrderItem, 'Création de OrderItem');

        System.debug('OrderItem created: ' + testOrderItem);

        // Récupérer l'Order pour vérifier que le TotalAmount est mis à jour
        testOrder = [SELECT Id, TotalAmount, ShipmentCost__c, NetAmount__c FROM Order WHERE Id = :testOrder.Id];
        System.assertNotEquals(0, testOrder.TotalAmount, 'TotalAmount ne doit pas être à 0');

        // Étape 2 : Ajouter ShipmentCost__c pour calculer NetAmount__c
        testOrder.ShipmentCost__c = 50;
        update testOrder;

        Test.startTest();

        // Étape 3 :Chnager le statut à Ordered pour déclencher le calcul de NetAmount__c
        testOrder.Status = 'Ordered';
        update testOrder;

        Test.stopTest();

        
        // Étape 4 : Vérifier le calcul de NetAmount__c
        Order updatedOrder = [SELECT Id, NetAmount__c, TotalAmount, ShipmentCost__c FROM Order WHERE Id = :testOrder.Id];
        Decimal expectedNetAmount = updatedOrder.TotalAmount - updatedOrder.ShipmentCost__c;

        System.debug('Updated Order ID: ' + updatedOrder.Id);
        System.debug('Actual NetAmount__c: ' + updatedOrder.NetAmount__c);

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