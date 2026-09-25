import { existsSync } from "node:fs";
import { resolve as resolvePath, sep } from "node:path";
import { pathToFileURL } from "node:url";

const projectRoot = pathToFileURL(`${resolvePath(".")}${sep}`);

export function resolve(specifier, context, nextResolve) {
  if (specifier === "server-only") {
    return nextResolve(new URL("./server-only.mjs", import.meta.url).href, context);
  }
  if (specifier.startsWith("@/")) {
    const moduleUrl = new URL(`${specifier.slice(2)}.ts`, projectRoot);
    return nextResolve(existsSync(moduleUrl) ? moduleUrl.href : new URL(`${specifier.slice(2)}/index.ts`, projectRoot).href, context);
  }
  if (specifier.startsWith(".") && !/\.[cm]?[jt]sx?$/.test(specifier)) {
    return nextResolve(new URL(`${specifier}.ts`, context.parentURL).href, context);
  }
  return nextResolve(specifier, context);
}
