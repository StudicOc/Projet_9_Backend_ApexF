/**
 * @description       : Update Account revenue (Chiffre_d_affaire__c) based on Order updates
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-13-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger UpdateAccountCA on Order (after update) {
  Set<Id> accountIds = new Set<Id>();

  for (Order newOrder : trigger.new) {      
      if (newOrder.AccountId != null) {
          accountIds.add(newOrder.AccountId);
      }
  }
  if (!accountIds.isEmpty()) {
      Map<Id, Decimal> accountAmount = new Map<Id, Decimal>();
      // SOQL orders pour calculers les revenus totaux de chaque compte
      for (AggregateResult ordersSum : [
          SELECT  AccountId,Status, SUM(TotalAmount) totalRevenue 
          FROM Order
          WHERE Status = 'Ordered' AND AccountId IN :accountIds
          GROUP BY AccountId
      ]) {
        accountAmount.put((Id)ordersSum.get('AccountId'), (Decimal)ordersSum.get('totalRevenue'));
        System.debug('totalRevnue');
      }

      // Fetch related accounts and update their revenue
      List<Account> accountsToUpdate = new List<Account>();
      for (Id accountId : accountAmount.keySet()) {
          Account acc = new Account(Id = accountId);
          acc.Chiffre_d_affaire__c = accountAmount.get(accountId);
          accountsToUpdate.add(acc);
      }

      if (!accountsToUpdate.isEmpty()) {
          update accountsToUpdate;
      }
  }
}
