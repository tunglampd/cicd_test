```mermaid
sequenceDiagram
    participant User

    box Presentation Layer
    participant UI as UI
    participant Controller as Controller
    end

    box Domain Layer
    participant REPO as Repository
    end

    box Data Layer
    participant RepoImpl as Repo Implementation
    participant SV as Service
    end

    participant BE as Server

    alt not valid actions
    User ->> UI: request (input text,...)
    UI ->> Controller: pass to controller
    Controller->>Controller: validate actions
    Controller -->> UI: if error, notify
    end
    
    Controller->>REPO: send request to domain

    Note over Controller, REPO: Use
    Note over RepoImpl, REPO: Implement

    RepoImpl->>RepoImpl: get Csrf token if needed
    RepoImpl->>SV: send to api service
    SV->>BE: request to server
    BE->>SV: receive from server
    SV->>SV: deserialize response
    SV->>RepoImpl: return data
    RepoImpl->>RepoImpl: handle status code, errors, etc
    RepoImpl->>RepoImpl: caching if needed
    RepoImpl->>REPO: return data to domain layer
    REPO->>Controller: return data to controller
    Controller->>Controller: handle business logic
    Controller->>UI: update UI, show error
```



```mermaid
sequenceDiagram
    participant User as User
    participant MobileApp as Mobile App
    participant FirebaseServer as Firebase Server

    Note over User, FirebaseServer: Deeplink flow SOH app
    Note over User, MobileApp: User triggers dynamic link generation

    User->>FirebaseServer: Request to Generate Dynamic Link
    FirebaseServer->>FirebaseServer: Generate Dynamic Link
    FirebaseServer-->>MobileApp: Generated Dynamic Link
    MobileApp->>User: return dynamic link to user

    User->>MobileApp: open app from dynamic link

    MobileApp->>MobileApp: check app exists
    alt false 
    MobileApp->>User: direct to download link
    else true
    MobileApp->>MobileApp: verify app (correct info)
    alt false
    MobileApp->>User: direct to download link
    else true
    MobileApp->>MobileApp: open app, handle data, load webview
    MobileApp->>User: display to User
    end
    end


```



```mermaid
sequenceDiagram    

    participant Webapp as SPA/ Native App
    participant Server as API Server 
    participant DB as Database
    participant AS as AWS SES
    participant AE as Admin Email
    
    Note over Webapp, AE: app contact

    Webapp->>Server: [GET] /master/contact-items
    Server->>DB: request data
    DB->>DB: query data
    DB->>Server: return data
    Server->>Webapp: return inquiry list
    
    Webapp->>Webapp: create request_body Contact(name, email, phone, note, inquiries)
    Webapp->>Server: [POST] /contact (body: request_body)
    Server->>DB: request insert
    DB->>DB: insert data
    alt insert fail
    DB-->>Server: insert success or not
    Server-->>Webapp: return error
    else success
    
    Server->>+AS: request send mail
    end
    AS->>AE: send contact form to admin email
    AS-->>-Server: return 
    Server->> Webapp: return response

```


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
