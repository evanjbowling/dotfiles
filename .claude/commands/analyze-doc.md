Analyze the markdown document at `$ARGUMENTS` for clarity and conciseness.

Run these commands and use the output to inform your analysis:

```bash
mdstats "$ARGUMENTS"
mdlines "$ARGUMENTS" | sort | uniq -d
mdlines "$ARGUMENTS" | sort
```

Report the following sections:

## Statistics
Present the mdstats metrics in a readable summary. Convert reading times to minutes where helpful (e.g. "2 min 43 sec"). If code block lines or images account for more than 25% of total reading time, call that out — it may indicate the document leans heavily on examples or visuals.

## Exact duplicates
List any sentences from `uniq -d` output. These are the highest-priority finding: the exact same text appears in more than one place. Note where each occurrence likely comes from (prose vs. list item vs. repeated section) if you can infer it.

## Similar sentences
From the sorted `mdlines` output, identify sentences that are semantically similar but not exact duplicates. Look especially for:
- Pro/con pairs that restate the same point with different framing
- Sentences that share a subject and verb but vary only in qualifier words
- List items that are paraphrases of nearby prose

## Recommendations
3–5 concrete, actionable suggestions for improving clarity and conciseness. Quote specific sentences where possible. Focus on what to consolidate, cut, or restructure — not on style.
