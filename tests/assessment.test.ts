import assert from "node:assert/strict";
import test from "node:test";

import { answerRank, rankApplications, validatePreference } from "../lib/answer-preferences";
import { ensureWeights, setWeightAndRebalance, weightsAreValid } from "../lib/field-weights";
import type { ApplicationField, SubmittedApplication } from "../lib/listing-types";

const fields: ApplicationField[] = [
  { id: "household", label: "Haushalt", type: "number", required: true, preference: { mode: "number-closest", ideal: "3" }, weight: 60 },
  { id: "moveIn", label: "Einzug", type: "date", required: true, preference: { mode: "date-closest", ideal: "2027-01-01" }, weight: 40 },
  { id: "name", label: "Name", type: "text", required: true, weight: 0 },
];

function application(id: string, household: string, moveIn: string): SubmittedApplication {
  return {
    id,
    listingId: "listing",
    answers: { household, moveIn, name: id },
    fields,
    createdAt: `2026-09-${id === "a" ? "01" : id === "b" ? "02" : "03"}T12:00:00.000Z`,
  };
}

test("Gewichte bleiben beim Verschieben insgesamt bei 100 Prozent", () => {
  const changed = setWeightAndRebalance(fields, "household", 75);
  assert.deepEqual(changed.map((field) => field.weight), [75, 25, 0]);
  assert.equal(weightsAreValid(changed), true);
  assert.deepEqual(ensureWeights(changed), changed);
});

test("ungültige Präferenzen werden vor der Bewertung abgewiesen", () => {
  assert.throws(() => validatePreference("number", { mode: "number-closest", ideal: "abc" }), /Zahl/);
  assert.throws(() => validatePreference("date", { mode: "date-closest", ideal: "2027-02-30" }), /Datum/);
  assert.throws(() => validatePreference("text", { mode: "regex", ideal: "[" }), /Regex/);
});

test("fehlende Antworten liegen hinter vorhandenen Antworten", () => {
  assert.equal(answerRank(fields[0], undefined), Number.POSITIVE_INFINITY);
  assert.ok(answerRank(fields[0], "4") < answerRank(fields[0], undefined));
});

test("Rangliste addiert Beiträge aus mehreren Kriterien und behandelt Gleichstand", () => {
  const ranked = rankApplications([
    application("a", "3", "2027-01-01"),
    application("b", "2", "2027-01-01"),
    application("c", "5", "2027-03-01"),
  ], fields);

  assert.deepEqual(ranked.map((item) => item.application.id), ["a", "b", "c"]);
  assert.deepEqual(ranked.map((item) => item.points), [180, 120, 0]);
  assert.deepEqual(ranked[0].contributions, { household: 120, moveIn: 60 });
  assert.equal(ranked[0].points, Object.values(ranked[0].contributions).reduce((sum, value) => sum + value, 0));
});
