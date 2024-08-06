/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-06-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class AccountCAService {
    public static void processOrdersUpdateAccount(List<Order> orders) {
        Set<Id> accountIds = new Set<Id>();
        
// Collecte les identifiants de compte des commandes asssociés
        for (Order ord : orders) {
            if (ord.AccountId != null) {
                accountIds.add(ord.AccountId);
            }
        }
        
        if (accountIds.isEmpty()) {
            return;
        }
        Map<Id, Decimal> accountAmount = new Map<Id, Decimal>();

 // Calcule du revenu total de chaque compte 
        for (AggregateResult ordersSum : [
            SELECT AccountId, SUM(TotalAmount) totalRevenue 
            FROM Order
            WHERE Status = 'Ordered' AND AccountId IN :accountIds
            GROUP BY AccountId
        ]) 
        
        {
            accountAmount.put((Id)ordersSum.get('AccountId'), (Decimal)ordersSum.get('totalRevenue'));
        }

        // Liste des comptes à mettre à jour
        List<Account> accountsToUpdate = new List<Account>();
        for (Id accountId : accountAmount.keySet()) {
            Account acc = new Account(Id = accountId);
            acc.Chiffre_d_affaire__c = accountAmount.get(accountId);
            accountsToUpdate.add(acc);
        }

        // Update dans la BDD
        
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}