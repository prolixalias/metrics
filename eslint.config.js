import js from "@eslint/js";
import globals from "globals";

export default [
  js.configs.recommended,
  {
    files: ["source/**/*.mjs"],
    languageOptions: {
      ecmaVersion: 2021,
      sourceType: "module",
      globals: {
        ...globals.node,
        ...globals.es2021,
        document: "readonly",
        window: "readonly",
        XMLSerializer: "readonly"
      }
    },
    rules: {
      "no-unused-vars": ["error", { argsIgnorePattern: "^_", caughtErrorsIgnorePattern: "^_" }],
      semi: ["error", "never"],
      quotes: ["error", "double", { avoidEscape: true }]
    }
  },
  {
    files: ["source/plugins/tweets/index.mjs"],
    rules: {
      "no-misleading-character-class": "off"
    }
  }
];