# Superbadge Apex Callouts: Fase 3 - Accessibility Project Billing

## Descrição do Desafio
Nesta fase, o objetivo foi construir uma integração com o sistema de faturamento de uma companhia de seguros para reembolsar os custos de intérpretes de ASL (Língua de Sinais Americana) em workshops de bem-estar. Diferente das fases anteriores que utilizavam REST, este cenário corporativo exigiu o consumo de uma **API SOAP**, garantindo o faturamento preciso e oportuno dos projetos de acessibilidade.

---

## Implementação Técnica
A solução foi arquitetada utilizando a conversão de um arquivo WSDL em classes Apex e a execução assíncrona para não travar a transação original do banco de dados:

### `BillingServiceProxy.cls` (Auto-gerada)
* **Nota Arquitetural:** Esta classe foi gerada de forma 100% automática utilizando a ferramenta nativa do Salesforce (**WSDL2Apex**) a partir do arquivo WSDL fornecido pela equipe de TI.
* Ela atua como o *Proxy* local, contendo a tradução exata dos tipos de dados (Wrapper Classes) e o método `WebServiceCallout.invoke`, que abstrai toda a complexidade da montagem do envelope XML do protocolo SOAP.

### `AccessibilityProjectBilling.cls`
* Contém o método `callBillingService`, que é acionado por uma Trigger (`WorkshopTrigger`) sempre que um projeto de acessibilidade é criado.
* Utiliza a anotação **`@future(callout=true)`**, obrigatória para permitir que integrações HTTP sejam disparadas a partir do contexto síncrono de uma Trigger de banco de dados.
* **Segurança e Melhores Práticas:** As credenciais de autenticação da API não estão *hardcoded* (escritas diretamente) no código. Foram utilizados *Merge Fields* (`{!$Credential.BillingServiceCredential.username}` e `password`), permitindo que o Salesforce injete os segredos dinamicamente no momento da execução a partir de uma **Named Credential** segura.
* Após a resposta bem-sucedida do servidor SOAP, o status do registro local (`Accessibility_Project__c`) é atualizado para 'Complete'.

---

## Conceitos Chave Demonstrados
* Integração SOAP utilizando classes Proxy (WSDL2Apex).
* Uso de classes Wrapper (encapsulamento de dados) para envio de *Payloads* complexos.
* Execução Assíncrona com métodos `@future(callout=true)`.
* Segurança de integrações corporativas evitando *Hardcoding* de senhas e *endpoints* reais (Named Credentials).
