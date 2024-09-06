public with sharing class OrderNetAmountService {

    public static void calculateNetAmount(List<Order> orders) {
        if (orders == null || orders.isEmpty()) {
            return;
        }

        for (Order order : orders) {
            if (order.TotalAmount != null) {
                if (order.ShipmentCost__c != null) {
                    // Calcule NetAmount__c en soustrayant ShipmentCost__c de TotalAmount
                    order.NetAmount__c = order.TotalAmount - order.ShipmentCost__c;
                } else {
                    // Si ShipmentCost__c est null, NetAmount__c doit être égal à TotalAmount
                    order.NetAmount__c = order.TotalAmount;
                }
            }
        }
        System.debug('Commandes traitées : ' + orders);
    }
}
