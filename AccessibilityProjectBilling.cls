public class AccessibilityProjectBilling {
    
    // @future(callout=true) Avisa a plataforma que isso é assincrono e fara uma chamada externa
    @future(callout=true)
    public static void callBillingService(String projectId, Decimal billAmount) {
        
        // Instancia a classe Wrapper e preenche com os 4 dados exigidos
        BillingServiceProxy.project projectWrap = new BillingServiceProxy.project();
        projectWrap.projectId = projectId;
        projectWrap.billAmount = billAmount;
        
        // O salesforce entende essas strings e injeta a senha de forma criptografada na hora do envio
        projectWrap.username = '{!$Credential.BillingServiceCredential.username}';
        projectWrap.password = '{!$Credential.BillingServiceCredential.password}';
        
        // Instancia o Port 
        BillingServiceProxy.InvoicesPortSoap11 proxy = new BillingServiceProxy.InvoicesPortSoap11();
        
        try {
            // Envia o Wrap pronto
            String response = proxy.billProject(projectWrap);
            
            // Se a chamada nao estourar erro e retornar algo, marca a chamada como complete
            if (response != null) {
                Accessibility_Project__c ap = new Accessibility_Project__c(
                    Id = projectId,
                    Status__c = 'Complete'
                );
                update ap;
            }
        } catch (Exception e) {
            System.debug('Erro ao comunicar com o serviço SOAP: ' + e.getMessage());
        }
    }
}