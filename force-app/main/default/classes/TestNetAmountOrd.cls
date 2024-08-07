/**
 * @description       : Test class for OrderNetAmountService
**/
@isTest
private class TestNetAmountOrd {

    @isTest
    static void testNetAmountCalculation() {
        // Setup test data 
        Account testAccount = TestDataFactory.createAccount('Account 1');
        Order testOrder = TestDataFactory.createOrder(testAccount.Id);
        
        // Mettre à jour le statut de la commande 
        testOrder.Status = 'Ordered'; 
        update testOrder;
        
        // Appeler la méthode de la classe 
        Test.startTest();
        OrderNetAmountService.calculateNetAmount(new List<Order>{testOrder});
        Test.stopTest();

        // Récupérer les commandes mises à jour
        Order updatedOrder = [SELECT Id, NetAmount__c FROM Order WHERE Id = :testOrder.Id];
        
        // Vérifier que les montants nets sont corrects
        System.assertEquals( updatedOrder.NetAmount__c, 'Le montant net calculé est incorrect.');
    }
}
