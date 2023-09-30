import { createTypeSpecLibrary } from "@typespec/compiler";
import { versionPolicyRule } from "./rules/versionPolicy.rule.js";

export const myLibrary = createTypeSpecLibrary({
  name: "@contoso/typespec-library",
  diagnostics: {},
  linter: {
    rules: [versionPolicyRule],
    ruleSets: {
      recommended: {
        enable: { [`@contoso/typespec-library:${versionPolicyRule.name}`]: true },
      },
    },
  },
});

// optional but convenient
export const { reportDiagnostic, createDiagnostic, createStateSymbol } = myLibrary;