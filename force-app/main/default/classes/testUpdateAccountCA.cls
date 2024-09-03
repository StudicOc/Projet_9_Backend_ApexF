/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-14-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class TestUpdateAccountCA {

    @isTest static void testUpdateOrder() {
      
        // Créer des donnée
        Account testAccount = TestDataFactory.createAccount('Account 1');
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

 @isTest static void testAccountMultipleOrders() {
    // Créer un compte avec plusieurs commandes
    Account testAccountOrd = TestDataFactory.createAccountWithMultipleOrders(200);

    // Récupérer les commandes créées
    List<Order> orders = [SELECT Id, AccountId, TotalAmount FROM Order WHERE AccountId = :testAccountOrd.Id];

    // Créer un produit et une entrée de pricebook pour les commandes
    Product2 testProduct = TestDataFactory.createProduct2('Test Product');
    PricebookEntry testPricebookEntry = TestDataFactory.createPricebookEntry(testProduct.Id);

    // Ajouter un OrderItem à chaque commande et mettre à jour le statut en 'Ordered'
    List<OrderItem> orderItemsToInsert = new List<OrderItem>();
    for (Order ord : orders) {
        ord.Status = 'Ordered';  // Mise à jour du statut de la commande en 'Ordered'
        OrderItem oi = new OrderItem(
            OrderId = ord.Id,
            PricebookEntryId = testPricebookEntry.Id,
            Quantity = 1,
            UnitPrice = 100
        );
        orderItemsToInsert.add(oi);
    }
    // Insérer les OrderItems
    insert orderItemsToInsert;

     Test.startTest();
    // Mettre à jour les commandes après avoir inséré les OrderItems
    update orders;

    // Re-fetch la liste des commandes mises à jour pour s'assurer que toutes les données sont cohérentes
    orders = [SELECT Id, AccountId, TotalAmount FROM Order WHERE AccountId = :testAccountOrd.Id];
    System.debug('Orders for account: ' + orders);

    // Traiter les commandes et mettre à jour le compte
    AccountCAService.processOrdersUpdateAccount(orders);

      Test.stopTest();
    // Récupérer le compte mis à jour
    Account updatedAccount = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :testAccountOrd.Id LIMIT 1];

    // Calculer le revenu attendu
    Decimal expectedRevenue = 0;
    for (Order ord : orders) {
        expectedRevenue += ord.TotalAmount;
    }

    // ASSERT
    System.assertEquals(expectedRevenue, updatedAccount.Chiffre_d_affaire__c, 'check');
}



@isTest
static void testEmptyOrderList() {
    
    Test.startTest();
    
    // Création d'une liste vide d'ordres
    List<Order> emptyOrderList = new List<Order>();
    
    // Appel de la méthode avec une liste vide
    AccountCAService.processOrdersUpdateAccount(emptyOrderList);
    
    Test.stopTest();
    
    // Aucune mis a jour
    List<Account> updatedAccounts = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN (SELECT AccountId FROM Order)];

    //ASSERT
    System.assertEquals(0, updatedAccounts.size(), 'No accounts should have been updated.');
    
    System.debug('Test passed for empty order list.');
}

}
   

