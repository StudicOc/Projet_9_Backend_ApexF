/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-30-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class TestUpdateAccountCA {

    @isTest static void test() {

        // Crée un compte de test
        Account testAccount = new Account(
            Name = 'Test Account'
        );
        insert testAccount; 

        // Crée un produit de test
        Product2 pd1 = new Product2(
            Name = 'Chemise Verte longue XYX',
            Family = 'Chemise'
        );
        insert pd1;

        // Crée l'entrée de catalogue de prix (PricebookEntry)
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = pd1.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        insert pbe;

        // Crée un ordre de test en utilisant le Price Book de test
        Order testOrder1 = new Order(
            Name = 'Test Order',
            AccountId = testAccount.Id,
            Status = 'Draft', // Statut correct pour un nouvel ordre
            Pricebook2Id = Test.getStandardPricebookId(),
            EffectiveDate = Date.today()
        );
        insert testOrder1;

        // Crée des OrderItems de test
        OrderItem orderItem1 = new OrderItem(
            OrderId = testOrder1.Id,
            PricebookEntryId = pbe.Id,
            Quantity = 10,
            UnitPrice = 150
        );
        insert orderItem1;

        OrderItem orderItem2 = new OrderItem(
            OrderId = testOrder1.Id,
            PricebookEntryId = pbe.Id,
            Quantity = 20,
            UnitPrice = 1000
        );
        insert orderItem2;  

        Test.startTest();

        // Mise à jour de l'ordre pour déclencher le trigger
        testOrder1.Status = 'Ordered';
        update testOrder1;

        // Calcule le chiffre d'affaires attendu
        Decimal expectedRevenue = (orderItem1.Quantity * orderItem1.UnitPrice) + (orderItem2.Quantity * orderItem2.UnitPrice);
        
        // Ajout d'une vérification pour le compte
        List<Account> updatedAccounts = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :testAccount.Id];
        
        // Vérifie que la liste n'est pas vide
        System.assert(!updatedAccounts.isEmpty(), 'La liste des comptes mis à jour ne doit pas être vide.');

        Account updatedAccount = updatedAccounts[0];
        System.assertEquals(expectedRevenue, updatedAccount.Chiffre_d_affaire__c, 'Le chiffre d\'affaires calculé doit correspondre.');

        Test.stopTest();
    }
}
