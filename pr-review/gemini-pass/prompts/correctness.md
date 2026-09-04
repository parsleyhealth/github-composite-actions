## Your pass: correctness

Find code in this diff that does the wrong thing. Ignore security, conventions and test coverage; three other reviewers own those.

Look for:

- **Logic errors.** Inverted or off-by-one conditions, wrong boolean operator, a branch that can never be reached, a `switch` missing a case that the type allows, arithmetic that is wrong at a boundary.
- **Null and undefined paths.** A value the diff now reads without checking, an optional field treated as required, an array index or `.find()` result used directly, a destructure of something that can be absent. Trace where the value actually comes from before you claim it can be missing.
- **Async and ordering.** A promise not awaited, a `useEffect` that fires with stale values or missing dependencies, a race between two writes to the same state, a cleanup that does not run, work started before the data it needs has loaded, an unawaited call whose rejection becomes unhandled.
- **State bugs.** State derived from props that goes stale, a mutation of an object or array that other code holds a reference to, a cache or memo whose key omits something it depends on, a reset that does not fire on the path that needs it.
- **Error handling.** A `catch` that swallows the error and continues with bad data, an error path that returns a success shape, a retry that repeats a non-idempotent action, a failure that leaves the user stuck with no way forward, a thrown error where the caller expects a returned one.
- **Behaviour changes callers do not expect.** A changed return type, a new nullable, a renamed or removed field, a different default, a narrowed or widened condition. Grep the callers and say which one breaks.
- **Loading and empty states.** A value that is `undefined` while it resolves but is treated as `false` or `0`, so the UI renders the wrong thing on first paint.

For each finding, name the input or state that triggers it and what the user or caller sees as a result.
