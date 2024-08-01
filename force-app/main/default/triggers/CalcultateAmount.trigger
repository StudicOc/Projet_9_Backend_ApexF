/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-01-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger CalcultateAmount on Order (before update) {
    new OrderNetAmountService(Trigger.new);
}


/*
calcule le montant net (NetAmount__c) pour chaque commande (Order) 
en soustrayant le coût de l'expédition (ShipmentCost__c) du montant total (TotalAmount) 
chaque fois qu'un enregistrement de commande est mis à jour. 
Si l'un de ces deux champs est nul, le calcul et la mise à jour du champ NetAmount__c ne sont pas effectués.*/