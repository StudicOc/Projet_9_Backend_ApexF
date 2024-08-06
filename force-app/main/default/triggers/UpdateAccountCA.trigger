/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-06-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

// Mettre à jour le chiffre d'affaires (Chiffre_d_affaire__c) sur les comptes après la mise à jour des commandes

trigger UpdateAccountCA on Order (after update) {

    AccountCAService.processOrdersUpdateAccount(Trigger.new);
}
