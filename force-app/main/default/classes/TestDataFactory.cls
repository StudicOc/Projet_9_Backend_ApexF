/**
 * @description       : Classe de fabrication de données pour les tests.
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-12-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class TestDataFactory {

    // Méthode pour créer un compte
    public static Account createAccount(String name) {
        Account acc = new Account(Name = name);
        insert acc;
        System.debug('Account created with ID: ' + acc.Id);
        return acc;
    }

    // Méthode pour créer un compte avec plusieurs commandes
    public static Account createAccountWithMultipleOrders(Integer numberOfOrders) {
        Account acc = new Account(Name = 'Test Account 2');
        insert acc;

        List<Order> orders = new List<Order>();
        for (Integer i = 0; i < numberOfOrders; i++) {
            Order order = new Order(
                AccountId = acc.Id,
                Status = 'Draft',
                Pricebook2Id = Test.getStandardPricebookId(),
                EffectiveDate = Date.today(),
                Name = 'Test Order ' + i
            );
            orders.add(order);
        }
        insert orders;
        return acc;
    }

    // Méthode pour créer un produit
    public static Product2 createProduct2(String name) {
        Product2 prod = new Product2(
            Name = name,
            Family = 'Chemise'
        );
        insert prod;
        return prod;
    }

    // Méthode pour créer une entrée de Pricebook
    public static PricebookEntry createPricebookEntry(Id productId) {
        PricebookEntry pbooke = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = productId,
            UnitPrice = 1020,
            IsActive = true
        );
        insert pbooke;
        System.debug('Product ID: ' + pbooke.Id);
        return pbooke;
    }

    // Méthode pour créer une commande
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

    // Méthode pour créer un article de commande
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

    // Méthode pour créer une commande avec des articles
    public static Order createOrderWithItems(Id accountId, Integer numberOfItems, Decimal unitPrice) {
        Order order = createOrder(accountId);
        Id pricebookId = Test.getStandardPricebookId();
        
        Product2 product = createProduct2('Test Product');
        PricebookEntry pricebookEntry = createPricebookEntry(product.Id);
        
        for (Integer i = 0; i < numberOfItems; i++) {
            createOrderItem(order.Id, pricebookEntry.Id, 1, unitPrice);
        }
        
        return order;
    }
}
