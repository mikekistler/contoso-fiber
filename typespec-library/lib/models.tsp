
import "@typespec/http";
import "@typespec/openapi";

using TypeSpec.Http;
using OpenAPI;

namespace ApiLibrary;

// Common Error Model
@error
@doc("Error response")
model Error {
  @doc("A server-defined code that uniquely identifies the error.")
  @header("x-ms-error-code")
  code: string;
  @doc("Top-level error object")
  error: ErrorDetail;
}

@doc("Error details")
model ErrorDetail {
  @doc("A server-defined code that uniquely identifies the error.")
  code: string;
  @doc("A human-readable representation of the error.")
  message: string;
  @doc("An array of details about specific errors that led to this reported error.")
  details?: ErrorDetail[];
}

model Address {
  @doc("Address line 1")
  addressLine1: string;
  @doc("Address line 2")
  addressLine2?: string;
  @doc("City")
  city: string;
  @doc("State")
  state: string;
  @doc("Postal code")
  postalCode: string;
}

// Parameters

// Each operation should have an api-version query parameter
model ApiVersion {
  @doc("The version of the API in the form YYYY-MM-DD")
  @query("apiVersion") apiVersion: string;
}

// Standard parameters for list operations

/** The standard 'top' query  for list operations. */
model Top {
  @doc("The number of result items to return.")
  @query top?: int32;
}

/** The standard 'skip' query parameter for list operations. */
model Skip {
  @doc("The number of result items to skip.")
  @query skip?: int32 = 0;
}

/** The standard 'filter' query parameter for list operations. */
model Filter {
  @doc("Filter the result list using the given expression.")
  @query filter?: string;
}

/** The standard 'orderby' query parameter for list operations. */
model OrderBy {
  @doc("Expressions that specify the order of returned results.")
  @query({format: "csv"}) orderby?: string[];
}

// Models for conditional requests

@format("eTag")
scalar eTag extends string;

@doc("The 'ETag' response header")
model EtagHeader {
  @doc("The entity tag for the response.")
  @header("ETag") etag?: eTag;
}

@doc("Provides the 'If-*' headers to enable conditional (cached) responses")
model ConditionalRequestHeaders {
  @doc("The request should only proceed if an entity matches this string.")
  @header("If-Match") ifMatch?: eTag;

  @doc("The request should only proceed if no entity matches this string.")
  @header("If-None-Match") ifNoneMatch?: eTag;

  @doc("The request should only proceed if the entity was not modified after this time.")
  @header("If-Unmodified-Since") ifUnmodifiedSince?: utcDateTime;

  @doc("The request should only proceed if the entity was modified after this time.")
  @header("If-Modified-Since") ifModifiedSince?: utcDateTime;
}