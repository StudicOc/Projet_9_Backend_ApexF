/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-30-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class OrderNetAmountService {
    public OrderNetAmountService() {

        if (orderIds == null || orderIds.isEmpty()) {
            return;
        }

        for (Order order : trigger.new) {
            if (order.TotalAmount != null && order.ShipmentCost__c != null) {
                order.NetAmount__c = order.TotalAmount - order.ShipmentCost__c;
            }
        }    
    }
}