/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-10-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

trigger CalculMontant on Order (before insert, before update) {
    for (Order order : trigger.new) {
        if (order.TotalAmount != null && order.ShipmentCost__c != null) {
            order.NetAmount__c = order.TotalAmount - order.ShipmentCost__c;
        }
    }
}
