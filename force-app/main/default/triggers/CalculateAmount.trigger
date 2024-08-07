/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-07-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger OrderTrigger on Order (after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
          // Appeler la méthode calculateNetAmount de OrderNetAmountService
        OrderNetAmountService.calculateNetAmount(Trigger.new);
    }
}
