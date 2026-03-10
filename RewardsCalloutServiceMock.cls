@isTest
global class RewardsCalloutServiceMock implements HttpCalloutMock{

    //Variavel que quarda o codigo de status retornado
    global Integer statusCode;
    
    //Metodo construtor 
    global RewardsCalloutServiceMock(Integer code) {
        this.statusCode = code;
    }
    
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        
        // Simula interações de sucesso e erro
        if (this.statusCode == 200 || this.statusCode == 201) {
            res.setBody('{"status": "Success", "message": "Rewards processed."}');
        } else {
            res.setBody('{"status": "Error", "message": "Bad data or API outage."}');
        }
        
        res.setStatusCode(this.statusCode);
        return res;
    }
}