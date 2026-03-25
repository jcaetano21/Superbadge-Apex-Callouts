# Superbadge Apex Callouts: Fase 1 - Rewards Management

## Descrição do Desafio
O objetivo desta fase foi construir uma integração ativa (*Outbound*) para comunicar o Salesforce com um sistema externo de gerenciamento de recompensas. O desafio de negócio exigia identificar funcionários que atingiram uma meta de bem-estar (12 ou mais atividades concluídas no trimestre) e enviar seus dados de forma segura para uma API REST externa.

---

## Implementação Técnica
A solução foi arquitetada dividindo a responsabilidade entre processamento de dados em lote e o serviço de comunicação HTTP:

### `WellnessJourneyRewardsBatch.cls`
* Implementa as interfaces `Database.Batchable<sObject>` e **`Database.AllowsCallouts`** (essencial para permitir integrações a partir de um contexto assíncrono).
* Processa os registros do objeto `Wellness_Journey__c` no método `execute`.
* Agrupa as contagens por usuário e identifica os elegíveis.
* Estrutura os dados exigidos (`id`, `name`, `contactEmail`, `username`) e realiza a serialização para o formato JSON usando `JSON.serialize()`.
* Invoca o serviço de integração e registra o HTTP Status Code retornado nos logs do sistema.

### `RewardsCalloutService.cls`
* Atua exclusivamente como o cliente REST (API Client).
* Constrói a requisição HTTP configurando o método `POST` e o cabeçalho `Content-Type: application/json`.
* **Segurança:** Utiliza *Named Credentials* (`callout:IntegrationSB__BalancedLiving/rewards`) para rotear a chamada de forma segura, evitando a exposição de *endpoints* reais ou chaves de autenticação diretamente no código (*Hardcode*).

---

## Conceitos Chave Demonstrados
* Integração REST (POST)
* Processamento Assíncrono com Batch Apex
* Manipulação e Serialização de JSON
* Boas práticas de segurança em integrações com Named Credentials
