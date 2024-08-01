/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-01-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-01-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class AccountCAService {
    public static void processOrdersUpdateAccount(List<Order> orders) {
        Set<Id> accountIds = new Set<Id>();
        
        // Collect account IDs from the provided orders
        for (Order ord : orders) {
            if (ord.AccountId != null) {
                accountIds.add(ord.AccountId);
            }
        }
        
        if (accountIds.isEmpty()) {
            return;
        }
        
        Map<Id, Decimal> accountAmount = new Map<Id, Decimal>();

        // Calculer les revenus totaux pour chaque compte avec une requête agrégée
        for (AggregateResult ordersSum : [
            SELECT AccountId, SUM(TotalAmount) totalRevenue 
            FROM Order
            WHERE Status = 'Ordered' AND AccountId IN :accountIds
            GROUP BY AccountId
        ]) {
            accountAmount.put((Id)ordersSum.get('AccountId'), (Decimal)ordersSum.get('totalRevenue'));
        }

        // Préparer la liste des comptes à mettre à jour
        List<Account> accountsToUpdate = new List<Account>();
        for (Id accountId : accountAmount.keySet()) {
            Account acc = new Account(Id = accountId);
            acc.Chiffre_d_affaire__c = accountAmount.get(accountId);
            accountsToUpdate.add(acc);
        }

        // Mettre à jour les comptes si nécessaire
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }



    }

	public static void AccountCAService(List<Order> l){
	} 
}


    
