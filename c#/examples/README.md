# Examples

This directory contains **exemplar features** — fully completed examples that
demonstrate the expected output quality and structure when an AI agent generates
a C# / ABP feature using this harness.

> **⚠️ These are reference examples only.** They are NOT production code and
> are NOT part of any concrete project. They exist solely to show agents what
> a correctly structured feature looks like.

## Available Examples

| Example | Type | Description |
| --- | --- | --- |
| [`CreateProduct/`](CreateProduct/) | Command | Creates a new product entity with validation, permissions, and domain rules |

## How Agents Should Use Examples

1. Read the example `prompt-spec.md` to understand the expected spec format.
2. Read the example `feature-manifest.json` to understand the expected manifest
   format.
3. Use the patterns as a reference when generating new features — do NOT copy
   them verbatim.
4. Always follow the actual project rulebook and prompt spec for the feature
   being generated; the example is for structure guidance only.
