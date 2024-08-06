/**
 * @description       : Unit test for verifying the NetAmount calculation on Order.
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-06-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

@isTest
private class TestNetAmountOrd {

    @isTest
    static void testNetAmountCalculation() {
        // Setup test data
        Account testAccount = TestDataFactory.createAccount('Account 1');
        Product2 testProduct = TestDataFactory.createProduct2('Product 1');
        PricebookEntry testPriceBookEntry = TestDataFactory.createPricebookEntry(testProduct.Id);
        Order testOrder = TestDataFactory.createOrder(testAccount.Id);
        OrderItem testOrderItem1 = TestDataFactory.createOrderItem(testOrder.Id, testPriceBookEntry.Id, 15, 150);
       
        Test.startTest();

        testOrder.Status = 'Ordered';
        update testOrder;
    
        Test.stopTest();

        
        testOrder.ShipmentCost__c = 50;
        update testOrder;

     
        Decimal expectedRevenue = (testOrderItem1.Quantity * testOrderItem1.UnitPrice);
        Decimal expectedNetAmount = expectedRevenue - testOrder.ShipmentCost__c;

        Order updatedOrder = [SELECT Id, NetAmount__c, ShipmentCost__c, TotalAmount FROM Order WHERE Id = :testOrder.Id LIMIT 1];
        System.assertEquals(expectedNetAmount, updatedOrder.NetAmount__c, 'The NetAmount should be updated correctly.');
    }



}
