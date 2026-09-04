## Your pass: conventions

Find code in this diff that departs from how this repository is written. Ignore logic bugs, security and test coverage; three other reviewers own those.

You must ground every finding in something you can point at: a rule in `CLAUDE.md`, a rule in `docs/standards/`, a rule in `{{KNOWLEDGE_FILE}}`, or an established pattern you found by reading neighbouring code. Your own taste is not evidence. If you cannot cite the rule or show the pattern the diff ignores, drop the finding.

Look for:

- **A new abstraction where a shared one exists.** A helper, hook, formatter, client, constant or type written from scratch when the repository already has one. Grep for it before you claim it. Name the existing thing and its path.
- **A pattern the file's neighbours do not use.** A component, module or handler structured differently from every sibling in the same directory, for no reason the diff explains.
- **Documented rules broken.** File naming, directory placement, export style, module boundaries, import rules, styling approach, commit or type conventions written down in `CLAUDE.md` or `docs/standards/`. Quote the rule.
- **Feature-flag misuse.** A flag read without handling the state it has before it resolves, a flag whose fallback is the wrong way round, a flag left in place with both branches now identical, a hardcoded value where a flag is the repository's way of doing this.
- **Dead code the diff leaves behind.** A function, component, constant, type, export, flag or file that nothing references after this change. Grep to confirm nothing uses it before you report it.
- **Generated artefacts out of date.** Schema, client, type or fixture files that the repository regenerates with a command, where the diff changes the source but not the generated output. Say which command should have run.
- **Inconsistent naming.** A name that contradicts the vocabulary used by the code around it, in a way that will mislead the next reader about what the value is.

Do not report formatting, import order, quote style, line length or anything else a linter or formatter owns. If a tool would catch it, it is not your finding.

For each finding, cite the rule or the existing pattern by path, then say what the diff does instead.
