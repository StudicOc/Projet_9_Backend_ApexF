/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-30-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * 
 * 
**/

//réalisation et lancement d’un batch, mettant à jour le chiffre d’affaires de tous les comptes lors de la migration des données ;
global class UpdateAccounts implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext info){ 
        //Requeter seulement les comptes qui ont au moins une commande avec le Status 'Ordered'
        return Database.getQueryLocator(
         [SELECT Id, (SELECT Id, Status FROM Orders WHERE Status = 'Ordered') 
         FROM Account 
         WHERE Id IN (SELECT AccountId FROM Order WHERE Status = 'Ordered')]);
 
    }
     
    global void execute(Database.BatchableContext info, List<Account> scope){   
     Set<Id> accountIds = new Set<Id>();
         
     // Collecter les IDs des comptes dans le scope
     for (Account acc : scope) {
         accountIds.add(acc.Id);
     }
 
     AccountRevenueService.updateAccountRevenue(accountIds);
    }    
    global void finish(Database.BatchableContext info){
    } 
 }