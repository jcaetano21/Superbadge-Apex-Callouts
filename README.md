# Superbadge-Apex-Callouts

# Superbadge Apex Callouts: Fase 2 - Test Rewards Callout Service

## Descrição do Desafio
O objetivo desta fase foi garantir a integridade, segurança e confiabilidade da integração construída na Fase 1. Como o Salesforce proíbe estritamente a realização de chamadas HTTP (Callouts) reais para a internet durante a execução de testes unitários, o desafio exigiu a criação de um ambiente de simulação (*Mocking*) para validar o comportamento do sistema diante de cenários de sucesso e de falha (indisponibilidade da API externa), exigindo uma cobertura de código superior a 90%.

---

## Implementação Técnica
A solução foi construída utilizando o framework de testes nativo do Apex, dividida em duas classes principais:

### `RewardsCalloutServiceMock.cls`
* Implementa a interface nativa **`HttpCalloutMock`**, atuando como um "dublê" do servidor externo.
* Intercepta as requisições HTTP disparadas pelas classes de teste e devolve respostas simuladas (`HttpResponse`).
* Possui um construtor dinâmico que permite injetar diferentes *Status Codes* (ex: 200 para sucesso, 500 para erro).
* Retorna payloads JSON literais e predefinidos dependendo do cenário, validando a capacidade do sistema de interpretar diferentes respostas da API.

### `RewardsCalloutServiceTest.cls`
* **Preparação de Dados (`@testSetup`):** Cria 12 registros de `Wellness_Journey__c` dinamicamente. Para evitar erros de fuso horário e validações de trimestre, a classe espelha a exata lógica matemática do Batch para alocar a `Completion_Date__c` com precisão no trimestre anterior. Além disso, contorna problemas de tradução/localização de Orgs utilizando `UserInfo.getUserId()` no lugar de buscas *hardcoded* por Perfis.
* **Injeção de Dependência:** Utiliza o método `Test.setMock()` para forçar o Apex a utilizar nossa classe simuladora durante os testes de Callout.
* **Garantia de Cobertura:** Força a execução direta do método `execute` do Batch, injetando o escopo de dados manualmente para contornar a latência da fila assíncrona do Salesforce, garantindo assim os 90%+ de cobertura de código exigidos.

---

## Conceitos Chave Demonstrados
* Testes Unitários no Salesforce (`@isTest`, `@testSetup`).
* Simulação de integrações HTTP utilizando a interface `HttpCalloutMock`.
* Criação dinâmica de Massa de Dados à prova de falhas de localização/idioma.
* Estratégias para atingir alta Cobertura de Código em processos assíncronos (Batch).
