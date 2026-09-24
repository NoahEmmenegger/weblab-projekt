import type { ApplicationField } from "@/lib/listing-types";

export function distributeWeights(fields: ApplicationField[]): ApplicationField[] {
  if (!fields.length) return fields;
  const base = Math.floor(100 / fields.length);
  const remainder = 100 - base * fields.length;
  return fields.map((field, index) => ({ ...field, weight: base + (index < remainder ? 1 : 0) }));
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
  if (!fields.some((field) => field.id === id)) return fields;
  if (fields.length === 1) return [{ ...fields[0], weight: 100 }];
  const weight = Number.isFinite(requestedWeight) ? Math.min(100, Math.max(0, Math.round(requestedWeight))) : 0;
  const others = scaleWeights(fields.filter((field) => field.id !== id), 100 - weight);
  const byId = new Map(others.map((field) => [field.id, field]));
  return fields.map((field) => field.id === id ? { ...field, weight } : byId.get(field.id)!);
}

export function ensureWeights(fields: ApplicationField[]): ApplicationField[] {
  return fields.every((field) => field.weight === undefined) ? distributeWeights(fields) : fields;
}

export function weightsAreValid(fields: ApplicationField[]): boolean {
  return fields.every((field) => Number.isInteger(field.weight) && field.weight! >= 0 && field.weight! <= 100)
    && fields.reduce((sum, field) => sum + field.weight!, 0) === 100;
}
