global with sharing class RestServiceMock implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        if(req.getEndpoint().contains(RestService.AUTH_ENDPOINT)){
            res.setBody('{"id":"1", "access_token": "asdf"}');
        }
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        return res;
    }
}