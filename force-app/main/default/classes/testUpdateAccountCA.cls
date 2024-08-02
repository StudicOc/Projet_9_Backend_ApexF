@isTest
private class TestUpdateAccountCA {

    @isTest static void test() {
        // Creation de data
        Account testAccount = TestDataFactory.createAccount('Account 1');
        Product2 testProduct = TestDataFactory.createProduct2('Produit 1');
        PricebookEntry testPriceBookEntry = TestDataFactory.createPricebookEntry(testProduct.Id);
        Order testOrder = TestDataFactory.createOrder(testAccount.Id);
        OrderItem testOrderItem1 = TestDataFactory.createOrderItem(testOrder.Id, testPriceBookEntry.Id, 10, 150);
        OrderItem testOrderItem2 = TestDataFactory.createOrderItem(testOrder.Id, testPriceBookEntry.Id, 20, 1000);

        Test.startTest();

        // Mise à jour de l'ordre pour déclencher le déclencheur
        testOrder.Status = 'Ordered';
        update testOrder;

        Test.stopTest();

        // Calculate expected revenue
        Decimal expectedRevenue = (testOrderItem1.Quantity * testOrderItem1.UnitPrice) + (testOrderItem2.Quantity * testOrderItem2.UnitPrice);

        // Vérifier le compte
        Account updatedAccount = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :testAccount.Id LIMIT 1];

        // Asserts
        System.assertNotEquals(null, testAccount.Id, 'Account ID should not be null');
        System.assertEquals(expectedRevenue, updatedAccount.Chiffre_d_affaire__c, 'The calculated revenue should match.');
    }
}
