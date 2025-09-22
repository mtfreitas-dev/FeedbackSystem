@isTest 
public with sharing class GoogleSentimentServiceTest {

    @isTest 
    public static void testNegativeGoogleSentimentQueueable(){

        // Simula resposta da API
        // Simulate API response

        Test.setMock(HttpCalloutMock.class, new FeedbackNegativeHttpMock());

        // Cria um registro de Feedback fictício
        // Create a dummy Feedback record

        Feedback__c fb = new Feedback__c(
            Name__c = 'Teste',
            Comment__c = 'Produto péssimo',
            ContactEmail__c = 'teste@gmail.com'
        );
        insert fb;

        Test.startTest();

        // Enfileira o job (Queueable)
        // Queue the job (Queueable)

        System.enqueueJob(new GoogleSentimentService(fb.Id, fb.Comment__c));

        Test.stopTest();
        

        // Verifica se o sentimento foi atualizado
        // Checks if the sentiment has been updated

        Feedback__c updatedFb = [SELECT Id, Sentiment__c FROM Feedback__c WHERE Id = :fb.Id];
        System.assertEquals('Negative', updatedFb.Sentiment__c, 'O sentimento deveria ser Negative');

    } 

    @isTest 
    public static void testePositiveGoogleSentimentQueueable(){

        // Simula resposta da API
        // Simulate API response

        Test.setMock(HttpCalloutMock.class, new FeedbacbkHttpMock());

        // Cria um registro de Feedback fictício
        // Create a dummy Feedback record

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
        Test.stopTest(); 

        // Verifica se o sentimento foi atualizado
        // Checks if the sentiment has been updated

        Feedback__c updatedFb = [SELECT Id, Sentiment__c FROM Feedback__c WHERE Id = :fb.Id];
        System.assertEquals('Positive', updatedFb.Sentiment__c, 'O sentimento deveria ser Positive');
    }

    @isTest 
    public static void testNeutreGoogleSentimentQueueable(){
        
        // Simula resposta da API
        // Simulate API response

        Test.setMock(HttpCalloutMock.class, new FeedbacbkNeutreMock());

        // Cria um registro de Feedback fictício
        // Create a dummy Feedback record

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
        Test.stopTest(); 

        // Verifica se o sentimento foi atualizado
        // Checks if the sentiment has been updated
        
        Feedback__c updatedFb = [SELECT Id, Sentiment__c FROM Feedback__c WHERE Id = :fb.Id];
        System.assertEquals('Neutral', updatedFb.Sentiment__c, 'O sentimento deveria ser Neutral');
    }

    @isTest
    public static void testErrorGoogleSentimentQueueable(){

    // Simula resposta da API que retorna erro
    // Simulates API response that returns error

    Test.setMock(HttpCalloutMock.class, new FeedbackErrorHttpMock());

    // Cria um registro de Feedback fictício
    // Create a dummy Feedback record

    Feedback__c fb = new Feedback__c(
        Name__c = 'Teste',
        Comment__c = 'Erro ao analisar sentimento',
        ContactEmail__c = 'teste@gmail.com'
    );
    insert fb;

    Test.startTest();

    // Enfileira o job (Queueable)
    // Queue the job (Queueable)

    System.enqueueJob(new GoogleSentimentService(fb.Id, fb.Comment__c));
    Test.stopTest();

    // Busca o registro atualizado
    // Fetch the updated record
    Feedback__c updatedFb = [SELECT Id, Sentiment__c FROM Feedback__c WHERE Id = :fb.Id];

    // Validação do valor 'Erro'
    // Validation of the 'Error' value
    System.assertEquals('Unable to analyze', updatedFb.Sentiment__c, 
        'Em caso de falha da API o sentimento deve ser "Unable to analyze".');
}
}