# Superbadge Apex Callouts: Fase 4 - Test Billing Callout Service

## Descrição do Desafio
A etapa final deste projeto teve como foco garantir a resiliência e a confiabilidade da integração SOAP construída na Fase 3. O desafio exigiu a criação de um ambiente de testes unitários robusto para simular o comportamento da API da companhia de seguros, validando o processamento do Salesforce tanto em cenários de faturamento bem-sucedido quanto em falhas de comunicação, atingindo a rigorosa métrica de mais de 90% de cobertura de código.

---

## Implementação Técnica
Diferente das integrações REST que utilizam `HttpCalloutMock`, o protocolo SOAP no Salesforce exige uma interface de simulação específica. A solução foi estruturada da seguinte forma:

### `BillingCalloutServiceMock.cls`
* Implementa a interface nativa **`WebServiceMock`**, obrigatória para interceptar chamadas geradas por classes de Proxy WSDL.
* Possui um construtor dinâmico para injetar diferentes respostas (Sucesso ou Falha).
* Preenche o objeto de resposta `billProjectResponse_element` (gerado automaticamente pelo WSDL) e o injeta no mapa de retorno `response_x`, enganando o sistema com precisão para simular a resposta do servidor SOAP real.

### `BillingCalloutServiceTest.cls`
* **Cenários de Teste:** Cobre o "Caminho Feliz" (atualizando o status do projeto de acessibilidade para 'Complete') e o "Caminho Triste" (garantindo que o status não seja alterado em caso de erro da API).
* **Controle Assíncrono:** Utiliza os blocos `Test.startTest()` e `Test.stopTest()` para forçar a execução imediata do método `@future(callout=true)`, permitindo a validação dos resultados na mesma transação de teste.
* **Cobertura de Classes Geradas:** Implementa um método dedicado para instanciar as classes *Wrapper* (internas) geradas pelo WSDL2Apex. Isso é uma técnica avançada para garantir a alta cobertura de código em arquivos gerados por máquina, que frequentemente contêm variáveis ociosas.

---

## Conceitos Chave Demonstrados
* Testes de integração SOAP utilizando a interface `WebServiceMock`.
* Simulação de injeção de dependência com `Test.setMock(WebServiceMock.class, ...)`.
* Validação de métodos assíncronos (`@future`) em contexto de teste.
* Estratégias avançadas para atingir +90% de cobertura em classes Proxy geradas automaticamente (WSDL2Apex).
