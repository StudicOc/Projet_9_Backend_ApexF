/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-14-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class TestUpdateAccountCA {

    @isTest static void test() {
      
        // Créer des données de test
        Account testAccount = TestDataFactory.createAccount('Account 1');
        //Contract testContract = TestDataFactory.createContract(testAccount.Id);
        Product2 testProduct = TestDataFactory.createProduct2('Produit 1');
        PricebookEntry testPriceBookEntry = TestDataFactory.createPricebookEntry(testProduct.Id);
        Order testOrder = TestDataFactory.createOrder(testAccount.Id);
        OrderItem testOrderItem1 = TestDataFactory.createOrderItem(testOrder.Id, testPriceBookEntry.Id, 10, 150);
     

        // Vérifier l'état initial
        Account initialAccount = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :testAccount.Id LIMIT 1];
        System.assertEquals(null, initialAccount.Chiffre_d_affaire__c, 'Initial account revenue should be null.');

        Test.startTest();

        // Mettre à jour le statut de la commande
        testOrder.Status = 'Ordered';
        update testOrder;

        Test.stopTest();
        // Requêter la commande
       List<OrderItem> orderItems = [SELECT Id, OrderId, PricebookEntryId, Quantity, UnitPrice 
                              FROM OrderItem 
                              WHERE OrderId = :testOrder.Id];

        // Calculer le revenu total attendu
        Decimal expectedRevenue = (testOrderItem1.Quantity * testOrderItem1.UnitPrice);

        // Requêter l'Account
        Account updatedAccount = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :testAccount.Id LIMIT 1];

        System.debug('Updated Account ID: ' + updatedAccount.Id);
        System.debug('Actual NetAmount__c: ' + updatedAccount.Chiffre_d_affaire__c);
        // ASSERT : Vérifier que le revenu du compte est mis à jour correctement
        System.assertEquals(expectedRevenue, updatedAccount.Chiffre_d_affaire__c, 'The account revenue should be updated correctly.');
    }
}