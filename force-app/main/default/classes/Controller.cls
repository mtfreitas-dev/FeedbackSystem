public with sharing class Controller {

    @AuraEnabled
    public static Map<String, Integer> getDataGraficBar(Integer days, List<String> category){

        if(days == null){
           days = 1000;
        }

        if(category.isEmpty()){
            category.add('Support');
            category.add('Product');
            category.add('Delivery');
        }

        Map<String, Integer> fbData = new Map<String, Integer>();
        Datetime dtBase = System.now() - days;

        fbData.put('Positive', 0);
        fbData.put('Negative', 0);
        fbData.put('Neutral', 0);

        System.debug('Categoria: ' + category);
        
        for(AggregateResult result : [SELECT Sentiment__c, COUNT(Id) total FROM Feedback__c WHERE CreatedDate >= :dtBase AND Category__c = :category GROUP BY Sentiment__c]){
            String sentiment = String.valueOf(result.get('Sentiment__c'));
            Integer total = Integer.valueOf(result.get('total'));
            fbData.put(sentiment, total);
        }
        
        return fbData;
    }

    @AuraEnabled
    public static Map<Integer, Integer> getDataGraficDonut(Integer days, List<String> category){

        if(days == null){
           days = 1000;
        }

        if(category.isEmpty()){
            category.add('Support');
            category.add('Product');
            category.add('Delivery');
        }

        Map<Integer, Integer>  fbData = new Map<Integer, Integer>();
        Datetime dtBase = System.now() - days;
        System.debug('Data calculada: ' + dtBase);

        

        for(Integer i = 1; i < 6; i++){
            fbData.put(i, 0);
        }

        for(AggregateResult result : [SELECT Rating__c, COUNT(Id) total from Feedback__c WHERE CreatedDate >= :dtBase AND Category__c = :category GROUP BY Rating__c]){
            Integer total = Integer.valueOf(result.get('total'));
            Integer rating = Integer.valueOf(result.get('Rating__c'));
            fbData.put(rating, total);
        }

        return fbData;
    }
}