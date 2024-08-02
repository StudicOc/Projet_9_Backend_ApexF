public with sharing class TestDataFactory {

    public static Account createAccount(String name) {
        Account acc = new Account(Name = name);
        insert acc;
        return acc;
    }

    public static Product2 createProduct2(String name) {
        Product2 prod = new Product2(
            Name = name,
            Family = 'Chemise'
        );
        insert prod;
        return prod;
    }

    public static PricebookEntry createPricebookEntry(Id productId) {
        PricebookEntry pbooke = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = productId,
            UnitPrice = 1020,
            IsActive = true
        );
        insert pbooke;
        return pbooke;
    }

    public static Order createOrder(Id accountId) {
        Order testOrder = new Order(
            Name = 'Test Order',
            AccountId = accountId,
            Status = 'Draft',
            Pricebook2Id = Test.getStandardPricebookId(),
            EffectiveDate = Date.today()
        );
        insert testOrder;
        return testOrder;
    }

    public static OrderItem createOrderItem(Id orderId, Id pricebookEntryId, Integer quantity, Decimal unitPrice) {
        OrderItem orderItem = new OrderItem(
            OrderId = orderId,
            PricebookEntryId = pricebookEntryId,
            Quantity = quantity,
            UnitPrice = unitPrice
        );
        insert orderItem;
        return orderItem;
    }
}
