public class RewardsCalloutService{

    public static Integer submitUsersForRewardCallout(String jsonBody) {
        // Set Endpoint from Named Credential

        HttpRequest req = new HttpRequest();
        
        // Utilizacao de Callout, busca diretamente a URL base e credenciais no setup
        req.setEndpoint('callout:IntegrationSB__BalancedLiving/rewards');
        
        // Elemento POST indicaa envio de dados a plataforma externa(REST API nesse exemplo)
        req.setMethod('POST');
        
        // Indicacao para o server que recebe a menssagem que os dados estao estruturados em JSON
        req.setHeader('Content-Type', 'application/json');

        //Insercao dos dados ao mensageiro
        req.setBody(jsonBody);

        //Make HTTP Callout

        //Instanciacao do objeto Http para realizar o callout
        Http http = new Http();

        //Resposta do callout
        HttpResponse res = http.send(req);
        
        // Retorna o status code da resposta do callout
        return res.getStatusCode();
            
    }
}