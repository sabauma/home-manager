---
description: Simplify a pull request description so that reviewer without context can quickly understand the purpose of the pull request.
---

If there are one or more open pull requests related to this branch or workspace, simplify the pull request description. Assume you are a busy code reviewer without context on the changes. How would you want to come up to speed quickly on the reason for the pull request?

- DO start with a brief summary of the changes, favor information about _why_ the pull request exists.
- DO follow with a summary of the problem the pull request fixes.
- DO keep the description to about 250 words or less.
- DO use markdown formatting to better convey information.
- DO put the BEGIN_PUBLIC/END_PUBLIC block (if one is necessary) at the bottom of the description. These do not count against he 250 word limitation, but do make these nice to read also ;).

- DO NOT include information about the process you went through to solve the problem.
- DO NOT list the tests run to confirm the solution.
- DO NOT describe every change in detail.
- DO NOT format the description with a limited character width like a commit message.
- DO NOT use em dash characters. Prefer complete sentences, or a spaced hyphen ( - ) where a pause is genuinely needed.

This file covers what goes in the description. For how the sentences should sound, also read `~/.dotfiles/config/shared/writing-voice.md`.

The reviewer will ask for more details if they need to know them, and we can provide details via comments when they do ask.

If there are not any pull requests associated  with this workspace, let the user know and ask if they can provide one for you to adjust.
