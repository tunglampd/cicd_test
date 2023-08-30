

```mermaid
sequenceDiagram    

    participant Webapp as SPA/ Native App
    participant Server as API Server 
    participant DB as Database
    

    Webapp->>Server: [GET] /master/contact-items
    Server->>DB: request data
    DB->>DB: query data
    DB->>Server: return data
    Server->>Webapp: return inquiry list

```