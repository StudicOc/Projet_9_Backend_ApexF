/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestCreationSOObject {

    @isTest
    static void myUnitTest() {
          
        Account testAccount = TestDataFactory.createAccount(' Account Sab');
        Product2 testProduct = TestDataFactory.createProduct2(' Product 1');
        PricebookEntry testPriceBookEntry = TestDataFactory.createPricebookEntry(testProduct.Id);
        Order testOrder = TestDataFactory.createOrder(testAccount.Id);
        OrderItem testOrderItem = TestDataFactory.createOrderItem(testOrder.Id, testPriceBookEntry.Id, 10, 150);

    System.debug('OrderItem created with ID: ' + testOrderItem.Id);
    System.assertNotEquals(null, testOrderItem.Id, 'OrderItem succes.');
    }
}