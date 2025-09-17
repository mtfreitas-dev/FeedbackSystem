@isTest
global class FeedbackHttpMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');

        res.setBody('{"documentSentiment":{"score":0.8}}');
        res.setStatusCode(200);
        return res;
    }
}
