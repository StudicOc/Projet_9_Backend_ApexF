/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-06-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger CalculateAmount on Order (before update) {
    new OrderNetAmountService(Trigger.new);
}
