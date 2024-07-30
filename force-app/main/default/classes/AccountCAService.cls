/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-30-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-30-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class AccountCAService {
    public AccountCAService(Set<Id> accountIds) {

        
        if (accountIds == null || accountIds.isEmpty()) {
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
}


    
