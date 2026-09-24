import type { ApplicationField } from "@/lib/listing-types";

export function distributeWeights(fields: ApplicationField[]): ApplicationField[] {
  const rated = fields.filter((field) => field.preference);
  if (!rated.length) return fields.map((field) => ({ ...field, weight: 0 }));
  const base = Math.floor(100 / rated.length);
  const remainder = 100 - base * rated.length;
  const weights = new Map(rated.map((field, index) => [field.id, base + (index < remainder ? 1 : 0)]));
  return fields.map((field) => ({ ...field, weight: weights.get(field.id) ?? 0 }));
}

// Preserve the other questions' proportions; assign rounding leftovers by largest fraction.
export function scaleWeights(fields: ApplicationField[], total = 100): ApplicationField[] {
  if (!fields.length) return fields;
  const current = fields.map((field) => Math.max(0, Number.isFinite(field.weight) ? field.weight! : 0));
  const sum = current.reduce((value, weight) => value + weight, 0);
  const raw = current.map((weight) => total * (sum ? weight / sum : 1 / fields.length));
  const rounded = raw.map(Math.floor);
  const leftovers = total - rounded.reduce((value, weight) => value + weight, 0);
  const order = raw.map((value, index) => ({ index, fraction: value - rounded[index] }))
    .sort((a, b) => b.fraction - a.fraction || a.index - b.index);
  for (let index = 0; index < leftovers; index++) rounded[order[index].index]++;
  return fields.map((field, index) => ({ ...field, weight: rounded[index] }));
}

export function setWeightAndRebalance(fields: ApplicationField[], id: string, requestedWeight: number): ApplicationField[] {
  const rated = fields.filter((field) => field.preference);
  if (!rated.some((field) => field.id === id)) return fields;
  if (rated.length === 1) return fields.map((field) => ({ ...field, weight: field.id === id ? 100 : 0 }));
  const weight = Number.isFinite(requestedWeight) ? Math.min(100, Math.max(0, Math.round(requestedWeight))) : 0;
  const others = scaleWeights(rated.filter((field) => field.id !== id), 100 - weight);
  const byId = new Map(others.map((field) => [field.id, field]));
  return fields.map((field) => field.id === id ? { ...field, weight } : byId.get(field.id) ?? { ...field, weight: 0 });
}

export function ensureWeights(fields: ApplicationField[]): ApplicationField[] {
  if (weightsAreValid(fields)) return fields;
  const rated = scaleWeights(fields.filter((field) => field.preference));
  const byId = new Map(rated.map((field) => [field.id, field.weight]));
  return fields.map((field) => ({ ...field, weight: byId.get(field.id) ?? 0 }));
}

export function weightsAreValid(fields: ApplicationField[]): boolean {
  return fields.every((field) => Number.isInteger(field.weight) && field.weight! >= 0 && field.weight! <= 100)
    && fields.every((field) => field.preference || field.weight === 0)
    && fields.reduce((sum, field) => sum + field.weight!, 0) === (fields.some((field) => field.preference) ? 100 : 0);
}
