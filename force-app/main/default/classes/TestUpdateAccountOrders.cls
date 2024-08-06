/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-06-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

@isTest
private class TestUpdateAccountOrders {

    // Test verify than 100 orders 
    @isTest static void testAccountOrders() {
        
        Account testOrders = TestDataFactory.createAccountWithMultipleOrders(100);

        Test.startTest();

        List<Order> orders = [SELECT Id, Name FROM Order WHERE AccountId = :testOrders.Id];
        for (Order ord : orders) {
            System.debug('Order Name: ' + ord.Name);
         
        }

        Test.stopTest();
        // Assert
        System.assertEquals(100, orders.size(), '100');


    }


    
}