/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-01-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global class UpdateAccounts implements Database.Batchable<sObject>{
    
    //ETAPE 1-----Récupérer tous les Accounts à traiter avec notre status "ORDERED3------//
    
  global Database.QueryLocator start(Database.BatchableContext info) { 
    return Database.getQueryLocator(

        [SELECT Id, (SELECT Id, Status, TotalAmount, AccountId FROM Orders WHERE Status = 'Ordered') 
         FROM Account 
         WHERE Id IN (SELECT AccountId FROM Order WHERE Status = 'Ordered')]);
}
    // ETAPE 2----------Traitement des compte récupérés-----//
    global void execute(Database.BatchableContext info, List<Account> scope){   
          List<Order> orders = new List<Order>();
        for (Account acc : scope) {
            orders.addAll(acc.Orders);
        }
        System.debug('Number of Orders to process: ' + orders.size());
        AccountCAService.processOrdersUpdateAccount(orders);
    }    
    global void finish(Database.BatchableContext info){
    } 
}