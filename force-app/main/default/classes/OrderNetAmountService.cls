/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-01-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-08-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class OrderNetAmountService {

    /**
     * @description : Calcule le montant net pour chaque commande en soustrayant ShipmentCost__c de TotalAmount.
     * @param orders : Liste des commandes pour lesquelles le montant net doit être calculé.
     */
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

                // Vérification des résultat
                System.debug('Order ID: ' + order.Id);
                System.debug('TotalAmount: ' + order.TotalAmount);
                System.debug('ShipmentCost__c: ' + order.ShipmentCost__c);
                System.debug('Calculated NetAmount__c: ' + order.NetAmount__c);
            }
            
        }
        
        update orders;
        System.debug('Orders to be updated: ' + orders);
    }
}