/**
 * @description       : Service pour mettre à jour le chiffre d'affaires des comptes à partir des commandes.
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-08-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class AccountCAService {
    public static void processOrdersUpdateAccount(List<Order> orders) {
        System.debug('Start of processOrdersUpdateAccount');
        Set<Id> accountIds = new Set<Id>();
        
        // Collecte les identifiants de compte des commandes associées
        for (Order ord : orders) {
            if (ord.AccountId != null) {
                accountIds.add(ord.AccountId);
            }
        }
        System.debug('Collected account IDs: ' + accountIds);
        
        if (accountIds.isEmpty()) {
            System.debug('No account IDs found, exiting method.');
            return;
        }
        
        Map<Id, Decimal> accountAmount = new Map<Id, Decimal>();

        // Calcule du revenu total de chaque compte
        for (AggregateResult ordersSum : [
            SELECT AccountId, SUM(TotalAmount) totalRevenue 
            FROM Order
            WHERE Status = 'Ordered' AND AccountId IN :accountIds
            GROUP BY AccountId
        ]) {
            accountAmount.put((Id)ordersSum.get('AccountId'), (Decimal)ordersSum.get('totalRevenue'));
        }
        System.debug('Account revenue calculated: ' + accountAmount);

        // Liste des comptes à mettre à jour
        List<Account> accountsToUpdate = new List<Account>();
        for (Id accountId : accountAmount.keySet()) {
            Account acc = new Account(Id = accountId);
            acc.Chiffre_d_affaire__c = accountAmount.get(accountId);
            accountsToUpdate.add(acc);
        }
        System.debug('Accounts to update: ' + accountsToUpdate);
        
        // Update dans la BDD
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
            System.debug('Accounts updated successfully.');
        } else {
            System.debug('No accounts to update.');
        }
        System.debug('End of processOrdersUpdateAccount');
    }
}