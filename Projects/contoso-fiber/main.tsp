import "@typespec/http";
import "@typespec/openapi3";
import "@typespec/versioning";
import "@contoso/typespec-library";

using TypeSpec.Http;
using OpenAPI;
using TypeSpec.Versioning;
using ApiLibrary;

@doc("""
  Contoso Fiber API
  This is the API for Contoso Fiber, a fiber internet service provider.
  """)
@service({
  title: "Contoso Fiber Service"
})
// contact and license are set with the @info decorator
@info({
  contact: {
    name: "API Support",
    email: "contact@contoso.com"
  },
  license: {
    name: "Apache 2.0",
    url: "https://www.apache.org/licenses/LICENSE-2.0.html"
  }
})
@server("https://api.contoso.com", "Public Contoso Fiber API")
@useAuth(OAuth2Auth<[
  {
    type: OAuth2FlowType.authorizationCode,
    authorizationUrl: "https://login.contoso.com/common/oauth2/v2.0/authorize",
    tokenUrl: "https://login.contoso.com/common/oauth2/v2.0/token",
    scopes: ["https://api.contoso.com/.default"],
  }
]>)
@versioned(Versions)
namespace Contoso.Fiber;

/** API versions */
enum Versions {
  `2023-08-30`,
  `2023-11-30`,
}

// Models

/** Contoso Fiber Customer */
model Customer {
  /** Customer ID */
  id: string;

  /** Customer Name */
  name: string;

  /** Customer Phone Number */
  phoneNumber: string;

  /** Customer Email Address */
  email: string;

  /** Customer Address */
  address: Address;

  /** Service plan */
  servicePlanId: ServicePlan.id;

  /** Installation date */
  installationOn: plainDate;
}

/** A service plan for fiber internet service */
model ServicePlan {
  /** Service Plan ID */
  id: string;

  /** Service Plan Name */
  name: string;

  /** Service Plan Description */
  description: string;
}

/** A service issue reported by a customer */
model ServiceTicket {
  /** Service Ticket ID */
  @visibility("read")
  id: string;

  /** Service Ticket Customer */
  customerId: Customer.id;

  /** Service Ticket Description */
  description: string;

  /** Service Ticket Created date-time */
  @visibility("read")
  createdAt: utcDateTime;

  /** Service Ticket Closed date-time */
  @visibility("read")
  closedAt: utcDateTime;

  /** Service Ticket Status */
  status: "open" | "assigned" | "resolved";

  /** Service Ticket Priority */
  priority: "low" | "medium" | "high";
}

/** Troublieshooting Guide */
@added(Versions.`2023-11-30`)
model Guide {
  /** Guide ID */
  id: string;

  /** Guide Name */
  name: string;

  /** Guide Description */
  description: string;

  /** Guide Keywords for searching */
  keyWords: string[];

  /** URL to PDF content */
  url: string;
}

@tag("Customers")
@route("/customers")
namespace Customers {
  op createCustomer is create<Customer>;
  op getCustomer is read<Customer>;
  op updateCustomer is update<Customer>;
  op deleteCustomer is delete<Customer>;
  op listCustomers is list<Customer, Top & Skip & Filter>;
}

@tag("Service Plans")
@route("/service-plans")
namespace ServicePlans {
  op createPlan is create<ServicePlan>;
  op getPlan is read<ServicePlan>;
  op updatePlan is update<ServicePlan>;
  op deletePlan is delete<ServicePlan>;
  op listPlans is list<ServicePlan>;
}

@tag("Service Tickets")
@route("/service-tickets")
namespace ServiceTickets {
  op createTicket is create<ServiceTicket>;
  op getTicket is read<ServiceTicket>;
  op updateTicket is update<ServiceTicket>;
  op deleteTicket is delete<ServiceTicket>;
  op listTickets is list<ServiceTicket, Top & Skip & Filter>;
}

@tag("Guides")
@route("/guides")
namespace Guides {
  //op getGuide is read<Guide>;
  @added(Versions.`2023-11-30`)
  op listGuides is list<Guide, Top & Skip & Filter>;
  @post op get(): string;
}
