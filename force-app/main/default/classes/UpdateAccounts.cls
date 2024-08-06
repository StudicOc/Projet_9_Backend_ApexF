/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-05-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global class UpdateAccounts implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext info){ 
        // Query only the accounts that have at least one order with the Status 'Ordered'
        // Sous select
        return Database.getQueryLocator(
         [SELECT Id, (SELECT Id, Status, TotalAmount FROM Orders WHERE Status = 'Ordered') 
         FROM Account 
         WHERE Id IN (SELECT AccountId FROM Order WHERE Status = 'Ordered')]);
    }
     
    global void execute(Database.BatchableContext info, List<Account> scope){   
        List<Order> orders = new List<Order>();
         
        // Collect orders from the accounts in the scope
        for (Account acc : scope) {
            for (Order ord : acc.Orders) {
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