/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-07-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class TestUpdateAccountOrders {

    @isTest static void testAccountOrders() {
        // Crée un compte avec 100 commandes
        Account testAccount = TestDataFactory.createAccountWithMultipleOrders(200);
        
        // Création d'un produit 
        Product2 testProduct = TestDataFactory.createProduct2('Test Product');
        PricebookEntry testPricebookEntry = TestDataFactory.createPricebookEntry(testProduct.Id);

        // Association des commandes existantes à des articles
        List<Order> orders = [SELECT Id FROM Order WHERE AccountId = :testAccount.Id];
        for (Order order : orders) {
            TestDataFactory.createOrderItem(order.Id, testPricebookEntry.Id, 2, 100);
        }

        // Update Order ID
        Order testOrder = [SELECT Id, Status FROM Order WHERE AccountId = :testAccount.Id LIMIT 1];
        
        // Status 'Ordered' pour déclencher le processus
        testOrder.Status = 'Ordered';
        
        Test.startTest();
        
        // Mise à jour de la commande
        update testOrder;
        
        Test.stopTest();
        
        // Calculer le revenu attendu
        Decimal expectedRevenue = 100 * 2 * 100; // 100 commandes, chaque commande a 2 articles à 100
        
        // Vérifier que le revenu du compte a été mis à jour correctement
        Account updatedAccount = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :testAccount.Id LIMIT 1];
        System.assertEquals(expectedRevenue, updatedAccount.Chiffre_d_affaire__c, 'Le revenu du compte devrait être mis à jour correctement.');
    }
}
