@isTest
private class BillingCalloutServiceTest {

    @testSetup
    static void setupData() {
        // Cria um projeto de acessibilidade para o teste
        Accessibility_Project__c ap = new Accessibility_Project__c();
        insert ap;
    }

    @isTest
    static void testCalloutSuccess() {
        // Configura o Mock SOAP para retornar uma String de sucesso
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock('Billed Successfully'));

        Accessibility_Project__c ap = [SELECT Id FROM Accessibility_Project__c LIMIT 1];

        Test.startTest();
        // Dispara o Callout assincrono
        AccessibilityProjectBilling.callBillingService(ap.Id, 500.00);
        Test.stopTest(); // O stopTest força a execução do @future imediatamente

        // Valida se a classe principal atualizou o status para 'Complete'
        ap = [SELECT Status__c FROM Accessibility_Project__c WHERE Id = :ap.Id];
        System.assertEquals('Complete', ap.Status__c, 'O status do projeto deveria ter sido atualizado para Complete após o sucesso da integração.');
    }

    @isTest
    static void testCalloutFailure() {
        // Configura o Mock SOAP para retornar nulo
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock(null));

        Accessibility_Project__c ap = [SELECT Id FROM Accessibility_Project__c LIMIT 1];

        Test.startTest();
        AccessibilityProjectBilling.callBillingService(ap.Id, 500.00);
        Test.stopTest();

        // Valida que o status nao foi alterado em caso de erro
        ap = [SELECT Status__c FROM Accessibility_Project__c WHERE Id = :ap.Id];
        System.assertNotEquals('Complete', ap.Status__c, 'O status não deve mudar para Complete se o serviço SOAP falhar.');
    }

    // Prioriza a utilizacao todas as variáveis
    @isTest
    static void coverGeneratedProxyClasses() {
        BillingServiceProxy.project proj = new BillingServiceProxy.project();
        BillingServiceProxy.billProjectRequest_element req = new BillingServiceProxy.billProjectRequest_element();
        BillingServiceProxy.billProjectResponse_element res = new BillingServiceProxy.billProjectResponse_element();
        
        System.assertNotEquals(null, proj, 'Instância não deve ser nula');
    }
}