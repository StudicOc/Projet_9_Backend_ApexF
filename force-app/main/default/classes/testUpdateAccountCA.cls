/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-06-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class TestUpdateAccountCA {

    @isTest static void test() {
        // Create test data
        Account testAccount = TestDataFactory.createAccount('Account 1');
        Product2 testProduct = TestDataFactory.createProduct2('Produit 1');
        PricebookEntry testPriceBookEntry = TestDataFactory.createPricebookEntry(testProduct.Id);
        Order testOrder = TestDataFactory.createOrder(testAccount.Id);
        OrderItem testOrderItem1 = TestDataFactory.createOrderItem(testOrder.Id, testPriceBookEntry.Id, 10, 150);
        OrderItem testOrderItem2 = TestDataFactory.createOrderItem(testOrder.Id, testPriceBookEntry.Id, 20, 1000);

        Test.startTest();

        // Update the order status
        testOrder.Status = 'Ordered';
        update testOrder;

        Test.stopTest();

        // Calculate expected total revenue
        Decimal expectedRevenue = (testOrderItem1.Quantity * testOrderItem1.UnitPrice) + (testOrderItem2.Quantity * testOrderItem2.UnitPrice);

        // ASSERT
        Account updatedAccount = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :testAccount.Id LIMIT 1];
        System.assertEquals(expectedRevenue, updatedAccount.Chiffre_d_affaire__c, 'The account revenue should be updated correctly.');
    }
}
