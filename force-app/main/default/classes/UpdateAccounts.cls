/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-12-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global class UpdateAccounts implements Database.Batchable<sObject>{
    
   global Database.QueryLocator start(Database.BatchableContext info){ 
       //Requeter seulement les comptes qui ont au moins une commande avec le Status 'Ordered'
       return Database.getQueryLocator(
        [SELECT Id, (SELECT Id, Status FROM Orders WHERE Status = 'Ordered') 
        FROM Account 
        WHERE Id IN (SELECT AccountId FROM Order WHERE Status = 'Ordered')]);

   }
    
   global void execute(Database.BatchableContext info, List<Account> scope){      
       List<Order> listOrders =  [SELECT Id, TotalAmount, AccountId, Status 
                                 FROM Order
                                 WHERE Status ='Ordered'];
       Set<Id> accountIds = new Set<Id>();
       for(Account a : scope) //The global scope indicates that the method can be called by any Apex code
       {
        accountIds.add(a);
       }
       
		/*for(integer i=0; i < scope.size(); i++){
			Account myAccount = scope[i];
			myAccount.Chiffre_d_affaire__c = 0;
           for(integer j=0; j < listOrders.size(); j++){
               if(listOrders[j].AccountId == myAccount.Id){
                   myAccount.Chiffre_d_affaire__c = myAccount.Chiffre_d_affaire__c + listOrders[j].TotalAmount;
               }                   
           }
       }*/
       
       update listOrders;
   }    
   global void finish(Database.BatchableContext info){
   } 
}