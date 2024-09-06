/**
 * @description       : Service pour mettre à jour le chiffre d'affaires des comptes à partir des commandes.
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-08-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
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
        System.debug('Identifiants de compte collectés : ' + accountIds);
        
        if (accountIds.isEmpty()) {
            System.debug('Aucun identifiant de compte trouvé');
            return;
        }
       
        //------- ETAPE 3 : Calcul du CA par Account-------//
        // Création de notre Map pour stocker le revenu total de chaque account // 
        Map<Id, Decimal> accountAmount = new Map<Id, Decimal>();
        
        //Requête SOQL Agrégée//
        for (AggregateResult ordersSum : [
            SELECT AccountId, SUM(TotalAmount) totalRevenue 
            FROM Order
            WHERE Status = 'Ordered' AND AccountId IN :accountIds
            GROUP BY AccountId
        ]) {
            // Associer chaque compte à son chiffre d'affaires 
            accountAmount.put((Id)ordersSum.get('AccountId'), (Decimal)ordersSum.get('totalRevenue'));
        }
        System.debug('Revenus du compte calculés :' + accountAmount);

        //------ETAPE 4: Création de la Liste des Accounts à Mettre à Jour-----//
        List<Account> accountsToUpdate = new List<Account>();
        for (Id accountId : accountAmount.keySet()) { // Récupération de tous les accountId
            Account acc = new Account(Id = accountId);
            acc.Chiffre_d_affaire__c = accountAmount.get(accountId);
            accountsToUpdate.add(acc); // Ajoutons l'account mis à jour dans la liste accountsToUpdate
        }
        System.debug('Comptes à mettre à jour :' + accountsToUpdate);
        //Vérification
        // Update dans la BDD
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
            System.debug('Comptes mis à jour avec succès.');
        } else {
            System.debug('Aucun compte à mettre à jour.');
        }
        System.debug('Fin du processusOrdersUpdateAccount');
    }
}