import { createTypeSpecLibrary } from "@typespec/compiler";
import { versionPolicyRule } from "./rules/versionPolicy.rule.js";

export const myLibrary = createTypeSpecLibrary({
  name: "ApiLibrary",
  diagnostics: {},
  linter: {
    rules: [versionPolicyRule],
    ruleSets: {
      recommended: {
        enable: { [`${versionPolicyRule.name}`]: true },
      },
    },
  },
});

// optional but convenient
export const { reportDiagnostic, createDiagnostic, createStateSymbol } = myLibrary;