@isTest
private class TestControllersOrders {

    @isTest
    static void testSumOrders() {
       
        // 1 - Création des données de test
      
        Account testAccount = TestDataFactory.createAccount('Account 1');
        Product2 testProduct = TestDataFactory.createProduct2('Produit 1');
        PricebookEntry testPriceBookEntry = TestDataFactory.createPricebookEntry(testProduct.Id);   
        Order testOrder = TestDataFactory.createOrder(testAccount.Id);
        OrderItem testOrderItem1 = TestDataFactory.createOrderItem(testOrder.Id, testPriceBookEntry.Id, 100, 250);
        OrderItem testOrderItem = TestDataFactory.createOrderItem(testOrder.Id, testPriceBookEntry.Id, 100, 250);

        // Mise à jour du statut de la commande pour qu'elle corresponde à la requête dans le contrôleur
        testOrder.Status = 'Ordered';
        update testOrder;

        // 2 - Initialisation du contrôleur et appel de la propriété
        Test.startTest();
        MyTeamOrdersController controller = new MyTeamOrdersController();
        Decimal total = controller.SumOders;  // Utilisation de la propriété
        Test.stopTest();

        // 3 - ASSERT
        System.assertEquals(50000, total, 'La somme totale des commandes devrait être 50000');
        System.debug('Somme total des commandes: ' + total);
    }
}
