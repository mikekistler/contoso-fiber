
import "@typespec/http";
import "@typespec/openapi";

using TypeSpec.Http;
using OpenAPI;

namespace ApiLibrary;

// List operations should return an object with nextLink -- not a bare array
model List<T extends TypeSpec.Reflection.Model> {
  @doc("List of {name}", T)
  value: T[];
  @doc("A link to the next page of results if present.")
  nextLink?: url;
}

/**
 * List resources in a collection.
 * @template T the resource type.
 * @template Params any additional parameters for the operation.
 */
@doc("Get a list of {name}", T)
@get op list<T extends TypeSpec.Reflection.Model, Params = {}>(
  ...Params,
  ...ApiVersion
): List<T> | Error;

/**
 * Template for an operation to create a resource.
 * @template T the resource type.
 */
@doc("Create a {name}", T)
@put op create<T extends TypeSpec.Reflection.Model>(
  @doc("The ID of the {name} to create", T)
  @path id: string,
  @body body: T,
  ...ApiVersion
): CreatedResponse & T | Error;

/**
 * Template for an operation to retrieve a resource.
 * @template T the resource type.
 */
@doc("Get a {name}", T)
@get op read<T extends TypeSpec.Reflection.Model>(
  @doc("The ID of the {name} to read", T)
  @path id: string,
  ...ApiVersion
): T | Error;

// Patch operations should accept a json-merge+patch body
model MergePatch<T extends TypeSpec.Reflection.Model> {
  @header contentType: "application/merge-patch+json";
  @body body: T;
}

/**
 * Template for an operation to update a resource.
 * @template T the resource type.
 */
@doc("Update a {name}", T)
@patch op update<T extends TypeSpec.Reflection.Model>(
  @doc("The ID of the {name} to updaet", T)
  @path id: string,
  @body body: MergePatch<T>,
  ...ApiVersion
): T | Error;

/**
 * Template for an operation to delete a resource.
 * @template T the resource type.
 */
@doc("Delete a {name}", T)
@delete op delete<T extends TypeSpec.Reflection.Model>(
  @doc("The ID of the {name} to delete", T)
  @path id: string,
  ...ApiVersion
): void | Error;
