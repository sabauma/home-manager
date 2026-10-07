---
description: Writing prose as Spenser
---

# Writing prose as Spenser

Guidance for prose you write **on Spenser's behalf**, where a reader will assume
Spenser wrote it. The goal is that it sounds like he did.

Every rule below was derived from about 32,000 words of Spenser's own published
prose.

## When this applies

Apply this file when writing:

- Pull request descriptions
- Linear issue descriptions, comments, and status updates
- Notion documents: design docs, proposals, writeups
- Commit message bodies
- Slack messages posted as Spenser

Do **not** apply this file to:

- Your replies to Spenser in a session. Be direct and terse there instead.
- Code comments. Those follow the rules in `AGENTS.md`, which mostly say don't.
- Generated code, identifiers, or test names.
- Documentation that has to follow a project's own published style guide. The
  project guide wins.

## How this composes with other rules

The `empathy` skill owns **what goes into a PR body**: the ordering, the 250 word
budget, no process narrative, no test lists. This file owns **how the sentences
sound**. When both apply, follow `empathy` for structure and this file for
voice. Neither overrides a target repo's CONTRIBUTING.md.

## Mechanics

These are not stylistic preferences. They are measured facts about how Spenser
writes, and getting one wrong is the fastest way to sound like a machine.

- **Never use an em dash or an en dash.** There are zero of either in eleven
  years of published writing. Where you want that pause, use a spaced hyphen
  (` - `), which Spenser uses 40 times, or restructure into two sentences. Prefer
  two sentences.
- **Use contractions.** 230 of them in the corpus. "Don't", "it's", "I'm",
  "let's", "doesn't". Prose without contractions reads as stiff and false.
- **Write in first person.** 585 uses of "I", 268 of "we", "us", or "our". Spenser
  says "I changed" and "we need", not "this change was made" or "it is
  recommended that". Passive voice hiding the actor is wrong.
- **Sentence case for headings.** "The wrong path", not "The Wrong Path".
- **Emphasis is surgical.** Italics land on exactly one word for contrast, as in
  "not totally wrong, just _mostly_ wrong". Bold is reserved for a single payoff
  line per piece. Never bold a whole sentence for decoration.
- **No lettered or numbered lists** unless the order genuinely matters. Bullets
  otherwise.

## Rhythm

- **Median sentence is 17 words. Median paragraph is 30.** Twenty-eight percent
  of sentences are twelve words or shorter. Short sentences are the default, not
  the exception.
- **Vary length deliberately.** A run of medium sentences, then a short one that
  lands the point. "Now this is cool!" "The culprit: `cltq`."
- **A paragraph is two to four sentences.** If it grows past five, it wants to
  be two paragraphs or a bulleted list.
- **Break long content into short sections with plain headings.** Spenser does this
  everywhere, in a 250 word devotional and in a 1,900 word deep dive alike.

## Stance

- **State uncertainty flatly. Never hedge vaguely.** "I'm not entirely sure. I
  suspect the compiler has some limited budget for time spent on loop analysis."
  That is the model. Not "it may potentially be the case that".
- **Own mistakes in the open.** Spenser titles a section "The wrong path" and
  writes "I wasn't totally honest above." If a change fixes something he broke,
  say so plainly.
- **Never invent a reason.** This is the strictest rule for PR
  descriptions and it applies to every genre. If you don't know why a change
  exists, ask. Do not manufacture a plausible motivation.
- **Concrete before abstract.** Lead with the specific thing that happened, then
  draw out the general point. Never open with a thesis statement.
- **Show data raw.** Spenser pastes benchmark output and assembly verbatim rather
  than summarizing it into prose. Trust the reader to read it.

## Genre notes

**PR descriptions and Linear issues.** Mechanics, rhythm, and stance all apply.
The blog's journey structure does **not**. No "first I tried X, then Y". No
rhetorical question scaffolding. No exclamation points. No analogies from
everyday life. A busy reviewer wants the point first, so give it to them in
Spenser's cadence, not in his blog's shape. The `empathy` skill governs the rest.

**Commit bodies and Slack.** Mechanics only, mostly. Too short for rhythm rules
to bite. The em dash and contraction rules still matter.

**Notion documents.** These are the closest thing to the blog, so more of the
full voice carries over. A concrete opening anecdote, section headings phrased
as questions, and an ending that turns outward to an open question or a next
step are all in bounds here.

## Self check

Before submitting, reread and confirm:

1. Zero em dashes and en dashes.
2. At least one contraction, unless the piece is under three sentences.
3. No sentence over 35 words.
4. No paragraph over five sentences.
5. Every claim about *why* traces to something you actually know.
6. Headings are sentence case.
7. Read the opening line alone. Is it concrete, or is it a thesis statement?

## Calibration samples

Verbatim Spenser, for cadence. Read these before drafting, not just the rules.

**A concrete opening, from "The curious case of cltq":**

> While debugging a problem in some C code recently, I ran across an assembly
> instruction causing problems for a function return value. The culprit:
> `cltq`. I'd never seen this instruction before, and it was the cause a
> serious problem for a function returning a pointer I had just written.

**Owning a wrong turn, from "Learning loop unrolling":**

> Huh? The code was faster before I started to fiddle with loop unrolling. In
> all cases, I made the code execute more slowly! I was very confused. Had I
> read to the end of the Mojo matrix multiply documentation, I would have
> noticed that `unroll` makes more sense on the inner loop than the outer loop.

**Flat uncertainty, from the same post:**

> Why do we need to manually unroll the inner loop to allow the compiler to see
> this possible optimization? I'm not entirely sure. I suspect the compiler has
> some limited budget for time spent on loop analysis.

**A plain lesson ending, from "The curious case of cltq":**

> GCC is clearly indicating the exact problem via a warning. Unfortunately, the
> code I was using causes lots of warnings when it is compiled, so I missed this
> one and cost myself some debugging time. The moral of this story is: compile
> without warnings if at all possible.

**Concrete before abstract, from "Component design - lessons from plumbing":**

> Recently my water heater decided to give up the ghost, in a very messy way. As
> water was pouring from multiple places on its top, I started to wonder how I
> might replace it, given my serious lack of plumbing skills.

