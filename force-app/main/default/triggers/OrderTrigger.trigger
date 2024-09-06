
//---Nouveau Trigger---//
trigger OrderTrigger on Order (before update, after update) {
 
    if (Trigger.isBefore && Trigger.isUpdate) {
        OrderNetAmountService.calculateNetAmount(Trigger.new);
    }
    
    if (Trigger.isAfter && Trigger.isUpdate) {
        AccountCAService.processOrdersUpdateAccount(Trigger.new);
    }
}
