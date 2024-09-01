@isTest
private class TestBatchAccount {

    @isTest
    static void testUpdateAllAccounts() {
     
        // Création de donnée
        Account account1 = TestDataFactory.createAccount('Account1');
        Account account2 = TestDataFactory.createAccount('Account2');

        Product2 product1 = TestDataFactory.createProduct2('Product 1');
        Product2 product2 = TestDataFactory.createProduct2('Product 2');

        PricebookEntry pbe1 = TestDataFactory.createPricebookEntry(product1.Id);
        PricebookEntry pbe2 = TestDataFactory.createPricebookEntry(product2.Id);

        Order testOrder1 = TestDataFactory.createOrder(account1.Id);
        Order testOrder2 = TestDataFactory.createOrder(account2.Id);

        OrderItem testOrderItem1 = TestDataFactory.createOrderItem(testOrder1.Id, pbe1.Id, 10, 150);
        OrderItem testOrderItem2 = TestDataFactory.createOrderItem(testOrder2.Id, pbe2.Id, 10, 150);

        // Instancier la classe batch
        UpdateAccounts batch = new UpdateAccounts();

        // Limite du gouverneur
        Test.startTest();
        // Exécuter le batch
        testOrder1.Status = 'Ordered';
        testOrder2.Status = 'Ordered';
        update testOrder1;
        update testOrder2;
        Id batchId = Database.executeBatch(batch);
        Test.stopTest();

        // Vérification des comptes
        Account updatedAccount1 = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :account1.Id];
        Account updatedAccount2 = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :account2.Id];

        // Calculer les valeurs attendues pour Chiffre_d_affaire__c
        Decimal expectedValue1 = 3 * 3 * 100; 
        Decimal expectedValue2 = 2 * 2 * 150; 

        // ASSERT0
        System.assertEquals(expectedValue1, updatedAccount1.Chiffre_d_affaire__c, 
            'Le champ Chiffre_d_affaire__c du compte 1 n\'a pas la valeur attendue après l\'exécution du batch.');

        System.assertEquals(expectedValue2, updatedAccount2.Chiffre_d_affaire__c, 
            'Le champ Chiffre_d_affaire__c du compte 2 n\'a pas la valeur attendue après l\'exécution du batch.');
    }
}
