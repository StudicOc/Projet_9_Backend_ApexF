public with sharing class AccountCAService {
    
    public static void processOrdersUpdateAccount(List<Order> orders) {
        // ETAPE 1 ---Initialisation d'un SET pour collecter les ID d'Accounts associés aux orders ----//
        Set<Id> accountIds = new Set<Id>();
        
        // ETAPE 2---Parcourir  la Liste des orders---//
        for (Order ord : orders) {
            if (ord.AccountId != null) {
                accountIds.add(ord.AccountId);
            }
        }
        
        //------- ETAPE 3 : Calcul du CA par Account-------//
        Map<Id, Decimal> accountAmount = new Map<Id, Decimal>();
        for (AggregateResult ordersSum : [
            SELECT AccountId, SUM(TotalAmount) totalRevenue 
            FROM Order
            WHERE Status = 'Ordered' AND AccountId IN :accountIds
            GROUP BY AccountId
        ]) {
            accountAmount.put((Id)ordersSum.get('AccountId'), (Decimal)ordersSum.get('totalRevenue'));
        }

        //------ETAPE 4: Création de la Liste des Accounts à Mettre à Jour-----//
        List<Account> accountsToUpdate = new List<Account>();
        for (Id accountId : accountAmount.keySet()) {
            Account acc = new Account(Id = accountId); 
            acc.Chiffre_d_affaire__c = accountAmount.get(accountId);
            accountsToUpdate.add(acc); 
        }
   
        // Update dans la BDD
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        } else {
            System.debug('Aucun compte à mettre à jour.');
        }
    }
}
