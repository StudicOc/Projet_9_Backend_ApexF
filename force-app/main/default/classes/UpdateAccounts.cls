/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-01-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global class UpdateAccounts implements Database.Batchable<sObject>{
    
    //ETAPE 1-----Requête SOQL pour récupérer tous les Accounts à traiter------//
    
  global Database.QueryLocator start(Database.BatchableContext info) { 
    return Database.getQueryLocator(
        //Sous-requête//
        [SELECT Id, (SELECT Id, Status, TotalAmount, AccountId FROM Orders WHERE Status = 'Ordered') 
         FROM Account 
         WHERE Id IN (SELECT AccountId FROM Order WHERE Status = 'Ordered')]);
}
    // ETAPE 2---------- Conversion du scope en liste de Account-----//
    global void execute(Database.BatchableContext info, List<Account> scope){   
        List<Order> orders = new List<Order>();
        for (Account acc : scope) {
            for (Order ord : acc.Orders) {
                // Filtrage//
                if (ord.Status == 'Ordered') {
                    orders.add(ord);
                }
            }
        }
 
        AccountCAService.processOrdersUpdateAccount(orders);
    }    
    global void finish(Database.BatchableContext info){
        // Any post-processing logic can go here
    } 
}