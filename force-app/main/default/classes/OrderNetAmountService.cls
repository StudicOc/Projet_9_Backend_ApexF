/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-01-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class OrderNetAmountService {
     
    public OrderNetAmountService(List<Order> orders) {
        if (orders == null || orders.isEmpty()) {
            return;
        }

        for (Order order : orders) {
            if (order.TotalAmount != null && order.ShipmentCost__c != null) {
                order.NetAmount__c = order.TotalAmount - order.ShipmentCost__c;
            }
        }
    }
}
