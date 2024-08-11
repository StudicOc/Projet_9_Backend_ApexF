/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestNetAmount {

    @isTest
    static void myUnitTest() {

        Account testAccount = TestDataFactory.createAccount('Account 1');
        Product2 testProduct = TestDataFactory.createProduct2('Produit 1');
        PricebookEntry testPriceBookEntry = TestDataFactory.createPricebookEntry(testProduct.Id);
        Order testOrder = TestDataFactory.createOrder(testAccount.Id);
      

        // Requête ORDER
        Order initialOrder = [SELECT Id, TotalAmount, ShipmentCost__c FROM Order WHERE Id = :testOrder.Id ];
        System.assertEquals(null, initialOrder.NetAmount__c, 'Initial Net amount should be null.');

        Test.startTest();

        // Mettre à jour le statut de la commande
        testOrder.Status = 'Ordered';
        update testOrder;

        Test.stopTest();

          // Requêter la commande
        List<Order> orders = [SELECT Id, NetAmount__c
                              FROM Order
                              WHERE Id = :testOrder.Id];
        Decimal netAmount = (orders.TotalAmount - orders.ShipmentCost__c);
         // Requêter l'Order
        Account updatedOrder = [SELECT Id,  NetAmount__c FROM Order WHERE Id = :testOrder.Id LIMIT 1];

        System.debug('Updated Order ID: ' + updatedOrder.Id);
        System.debug('Actual NetAmount__c: ' + updatedOrder.NetAmount__c);

            // ASSERT
        System.assertEquals(netAmount, updatedOrder.NetAmount__c, 'The NetAmount should be updated correctly.');
        

    }
}