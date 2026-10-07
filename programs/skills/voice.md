---
description: Rewrite existing prose so it sounds like Josh wrote it, using the rules in writing-voice.md.
---

Read `~/.dotfiles/config/shared/writing-voice.md` first. Everything below
depends on it, so do not skip it or work from memory of it.

## Find the target

Work out what you are being asked to rewrite, in this order:

1. Text pasted into this message, or a file path given as an argument.
2. A Linear issue identifier such as `ENG-1234`. Read it with
   `linear issue view ENG-1234 --no-pager` and rewrite the description, or a
   specific comment if the user named one.
3. The open pull request for the current branch or workspace. Rewrite the body.
4. If none of these apply, say so and ask the user what to rewrite.

## Rewrite it

- **Preserve the meaning exactly.** Do not add a claim, a reason, a benefit, or
  a caveat that is not already in the original. Do not remove substance to hit a
  rhythm target. If the original is missing a *why* that it clearly needs, point
  that out to the user rather than inventing one.
- **Apply the genre notes.** A PR body and a Notion doc get different amounts of
  the voice. Check which genre you are in before you start.
- **For a pull request body, also read and apply
  `~/.claude/commands/empathy.md`.** It owns the structure and the length
  budget. This file owns how the sentences sound.
- **Leave these alone, verbatim:** code blocks, command output, benchmark
  numbers, links, image references, Linear closing keywords such as
  `Fixes ENG-1234`, and any BEGIN_PUBLIC/END_PUBLIC block markers. You may
  rewrite prose *inside* a public block, since it still needs to read well.
- Run the self check from `writing-voice.md` before you show anything.

## Report back

Show the rewritten text in full. Follow it with a short list of what you
changed and which rule drove each change, so the user can push back where you
guessed wrong. Keep that list to the substantive changes. Do not itemize every
comma.

If the original is already in Josh's voice, say so and change nothing. Do not
churn text just because the command was invoked.

## Do not publish without approval

Never update a pull request, Linear issue, Notion page, or Slack message until
the user has seen the rewrite and approved it. Show first, then ask, then
update. For a local file, the same rule applies: show the change before writing
it.
