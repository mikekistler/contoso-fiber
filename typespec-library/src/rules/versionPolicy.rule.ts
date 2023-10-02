import { ModelProperty, Scalar, Type, createRule } from "@typespec/compiler";
import { isQueryParam } from "@typespec/http";

// Return true if the parameter is an `api-version` query parameter.
const isApiVersion = (p: ModelProperty) => {
  const type: ModelProperty["type"] = p.type;
  return p.name === "apiVersion" && !p.optional && (p.type as Scalar).name === "string";
};

export const versionPolicyRule = createRule({
  name: "version-policy",
  severity: "warning", // "Warning" is the only valid value
  description: `All operations must define an "api-version" query parameter.`,
  messages: {
    default: `Operation does not define an "api-version" query parameter.`,
  },
  create: (context) => {
    return {
      // This is called for every operation
      operation: (op) => {
        const params = op.parameters?.properties;
        if (![...params.values()].some((p) => 
              isApiVersion(p) && isQueryParam(context.program, p))
        ) {
          context.reportDiagnostic({
            target: op,
          });
        }
      },
    };
  },
});
