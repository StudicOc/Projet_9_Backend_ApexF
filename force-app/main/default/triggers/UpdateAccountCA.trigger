/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-14-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

// Mettre à jour le chiffre d'affaires (Chiffre_d_affaire__c) sur les comptes après la mise à jour des commandes

trigger UpdateAccountCA on Order (after update) {

    /*Set<Id> accountIds = new Set<Id>();

    // Collecter les IDs de comptes concernés
    for (Order newOrder : trigger.new) {      
        if (newOrder.AccountId != null) {
            accountIds.add(newOrder.AccountId);
        }
    }*/
    
    AccountCAService.processOrdersUpdateAccount(Trigger.new);
}

  
  