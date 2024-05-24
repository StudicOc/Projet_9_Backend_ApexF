trigger UpdateAccountCA on Order (after update) {
	
    set<Id> setAccountIds = new set<Id>();
/** 
 * TODO: refactor this method to include best practice of DML & SOQL 
 * 
 * 
 * 
*/
        
    for(integer i=0; i< trigger.new.size(); i++){
        Order newOrder= trigger.new[i];
       
        Account acc = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id =:newOrder.AccountId ];
        acc.Chiffre_d_affaire__c = acc.Chiffre_d_affaire__c + newOrder.TotalAmount;
         // Data DML operation
        update acc;
    }
}