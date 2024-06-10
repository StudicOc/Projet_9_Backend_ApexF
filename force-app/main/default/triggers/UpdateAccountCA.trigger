/**
 * @description       : Update Account revenue (Chiffre_d_affaire__c) based on Order updates
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-10-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger UpdateAccountCA on Order (after update) {
  Set<Id> accountIds = new Set<Id>();

  // Collect account IDs from the updated orders
  for (Order newOrder : trigger.new) {      
      if (newOrder.AccountId != null) {
          accountIds.add(newOrder.AccountId);
      }
  }

  if (!accountIds.isEmpty()) {
      // Map to hold the total revenue for each account
      Map<Id, Decimal> accountRevenueMap = new Map<Id, Decimal>();

      // Query orders to calculate total revenue for each account
      for (AggregateResult ar : [
          SELECT AccountId, SUM(TotalAmount) totalRevenue
          FROM Order
          WHERE Status = 'Ordered' AND AccountId IN :accountIds
          GROUP BY AccountId
      ]) {
          accountRevenueMap.put((Id)ar.get('AccountId'), (Decimal)ar.get('totalRevenue'));
      }

      // Fetch related accounts and update their revenue
      List<Account> accountsToUpdate = new List<Account>();
      for (Id accountId : accountRevenueMap.keySet()) {
          Account acc = new Account(Id = accountId);
          acc.Chiffre_d_affaire__c = accountRevenueMap.get(accountId);
          accountsToUpdate.add(acc);
      }

      if (!accountsToUpdate.isEmpty()) {
          // Update the accounts in the database
          update accountsToUpdate;
      }
  }
}
