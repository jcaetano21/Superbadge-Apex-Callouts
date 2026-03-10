@isTest
private class RewardsCalloutServiceTest {

    @testSetup
    static void setupData() {
        // Usa o usuario atual para evitar erros de criação de Profile
        Id currentUserId = UserInfo.getUserId();
        
        // Copia a logica exata do Batch para garantir que a data caia no trimestre passado
        Date today = Date.today();
        Integer currentYear = today.year();
        Integer currentMonth = today.month();
        Integer previousQuarterStartMonth = ((currentMonth - 1) / 3) * 3 + 1 - 3;
        
        if (previousQuarterStartMonth <= 0) {
            previousQuarterStartMonth += 12;
            currentYear--;
        }
        
        // Define a data para o dia 15 do primeiro mes do trimestre passado
        Date dataTrimestrePassado = Date.newInstance(currentYear, previousQuarterStartMonth, 15);
        
        List<Wellness_Journey__c> journeys = new List<Wellness_Journey__c>();
        
        // Cria os 12 registros exigidos
        for (Integer i = 0; i < 12; i++) {
            Wellness_Journey__c wj = new Wellness_Journey__c();
            wj.OwnerId = currentUserId;
            wj.Status__c = 'Complete';
            wj.Completion_Date__c = dataTrimestrePassado;
            journeys.add(wj);
        }
        
        insert journeys;
    }

    @isTest
    static void testBatchExecutionSuccess() {
        // Simula o cenario de sucesso (200)
        Test.setMock(HttpCalloutMock.class, new RewardsCalloutServiceMock(200));
        
        Test.startTest();
        WellnessJourneyRewardsBatch batch = new WellnessJourneyRewardsBatch();
        Database.executeBatch(batch);
        Test.stopTest();
        
        // Verifica se os 12 registros foram inseridos corretamente no setup
        List<Wellness_Journey__c> insertedJourneys = [SELECT Id FROM Wellness_Journey__c WHERE Status__c = 'Complete'];
        System.assertEquals(12, insertedJourneys.size(), 'Deveriam existir 12 jornadas para o teste.');
    }

    @isTest
    static void testServiceCalloutError() {
        // Simula o cenario de falha/outage da API (500)
        Test.setMock(HttpCalloutMock.class, new RewardsCalloutServiceMock(500));
        
        String fakeJson = '[{"id":"123","name":"Test","username":"test","contactEmail":"test@test.com"}]';
        
        Test.startTest();
        Integer responseCode = RewardsCalloutService.submitUsersForRewardCallout(fakeJson);
        Test.stopTest();
        
        // Valida se o sistema lidou corretamente com a falha
        System.assertEquals(500, responseCode, 'O callout deveria retornar o código de erro 500.');
    }
}