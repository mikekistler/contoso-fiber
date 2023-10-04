# Contoso Fiber

## Resources / relationships for Contoso Fiber REST API

```mermaid
erDiagram
    Customer { 
        string name
        string phoneNumber
        string email
        Address address
        Date installedOn
    }
    
    ServicePlan {
        string planType
        string description
    }
    
    ServiceTickets {
        Customer customer
        string description
        DateTime createdAt
        DateTime closedAt
        Status status "'open' | 'active' | 'closed'"
        Priority priority "'high' | 'medium' | 'low'"
    }
        
        
    Customer ||--|| ServicePlan : has
    
    Customer ||--|{ ServiceTickets : has
```
