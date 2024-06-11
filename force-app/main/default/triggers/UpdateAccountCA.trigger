/**
 * @description       : Update Account revenue (Chiffre_d_affaire__c) based on Order updates
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-11-2024
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
      //Carte pour contenir les revenus totaux de chaque compte
      Map<Id, Decimal> accountAmount = new Map<Id, Decimal>();

      // SOQL orders pour calculers les revenus totaux de chaque compte
      for (AggregateResult ordersSum : [
          SELECT  AccountId, SUM(TotalAmount) totalRevenue // Variable d'identification//
          FROM Order
          WHERE Status = 'Ordered' AND AccountId IN :accountIds
          GROUP BY AccountId
      ]) {
        accountAmount.put((Id)ordersSum.get('AccountId'), (Decimal)ordersSum.get('totalRevenue'));
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
