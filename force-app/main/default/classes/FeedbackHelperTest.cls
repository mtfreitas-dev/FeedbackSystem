@isTest
private class FeedbackHelperTest {

    @isTest
    static void testGoogleSentimentQueueable() {

        // Simula resposta da API
        // Simulate API response
        Test.setMock(HttpCalloutMock.class, new FeedbacbkHttpMock());

        // Cria um registro de Feedback fictício
        Feedback__c fb = new Feedback__c(
            Name__c = 'Teste',
            Comment__c = 'Produto muito bom',
            ContactEmail__c = 'teste@gmail.com'
        );
        insert fb;

        Test.startTest();
        // Enfileira o job (Queueable)
        // Queue the job (Queueable)
        System.enqueueJob(new GoogleSentimentService(fb.Id, fb.Comment__c));
        Test.stopTest(); // Executa o job assíncrono

        // Verifica se o sentimento foi atualizado
        // Checks if the sentiment has been updated
        Feedback__c updatedFb = [SELECT Id, Sentiment__c FROM Feedback__c WHERE Id = :fb.Id];
        System.assertEquals('Positive', updatedFb.Sentiment__c, 'O sentimento deveria ser Positive');
    }
}