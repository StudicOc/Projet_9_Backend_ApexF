/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-01-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class TestDataFactory {
    public TestDataFactory() {}

        public static Account createAccount() {
            Account acc = new Account(Name = 'Test Account 1');
            insert acc;
            return acc;
        
        }
    
}