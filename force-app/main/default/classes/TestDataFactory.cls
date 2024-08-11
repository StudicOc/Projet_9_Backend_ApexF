public with sharing class TestDataFactory {

    public static Account createAccount(String name) {
        Account acc = new Account(Name = name);
        insert acc;
        System.debug('Account created with ID: ' + acc.Id);
         return acc;
        }

    // CREATE ACCOUNT WITH MULTIPLE ORDERS //
     public static Account createAccountWithMultipleOrders (Integer numberOfOrders){

        Account accs = new Account(Name = 'Test Account 2');
        insert accs;

        List<Order> orders = new List<Order>();

           for (Integer i = 0; i < numberOfOrders; i++) {
               Order order = new Order(
                AccountId = accs.Id,
                Status = 'Draft',
                Pricebook2Id = Test.getStandardPricebookId(),
                EffectiveDate = Date.today(),
                Name = 'Test Order ' + i
               );
               orders.add(order);
           }
           
           // Insère toutes les commandes
           insert orders;
           return accs;

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
        System.debug('Order ID: ' + testOrder.Id);
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