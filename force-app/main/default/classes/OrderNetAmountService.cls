/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-07-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class OrderNetAmountService {
     
    public static void calculateNetAmount(List<Order> orders) {
         // Vérifier si la liste de commandes est nulle ou vide
        if (orders == null || orders.isEmpty()) {
            return;
        }

        for (Order order : orders) {
            // Vérifier si TotalAmount et ShipmentCost__c ne sont pas nuls
            if (order.TotalAmount != null && order.ShipmentCost__c != null) {
                 // Calculer NetAmount__c en soustrayant ShipmentCost__c de TotalAmount
                order.NetAmount__c = order.TotalAmount - order.ShipmentCost__c;
            }
        }

        update orders;
    }
}
