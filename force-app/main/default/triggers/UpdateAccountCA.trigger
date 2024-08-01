/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-01-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

// Mettre à jour le chiffre d'affaires (Chiffre_d_affaire__c) sur les comptes après la mise à jour des commandes

trigger UpdateAccountCA on Order (after update) {

    Set<Id> accountIds = new Set<Id>();

    // Collecter les IDs de comptes concernés
    for (Order newOrder : trigger.new) {      
        if (newOrder.AccountId != null) {
            accountIds.add(newOrder.AccountId);
        }
    }
    
    // Appeler la méthode du service pour mettre à jour les revenus du compte
    AccountCAService.AccountCAService(Trigger.new);
}

  
  /*la collecte des IDs de comptes (Set<Id> accountIds = new Set<Id>(); 
  et la boucle for (Order newOrder : trigger.new) { ... }) 
  et l'utilisation de la requête agrégée (for (AggregateResult ordersSum : [ ... ])) sont les parties où les collections sont utilisées pour minimiser les requêtes SOQL*/