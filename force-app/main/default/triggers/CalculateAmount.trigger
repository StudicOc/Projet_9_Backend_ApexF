/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-01-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger CalculateAmount on Order (before update) {
    if (Trigger.isBefore && Trigger.isUpdate) {
        OrderNetAmountService.calculateNetAmount(Trigger.new);
    }
}


