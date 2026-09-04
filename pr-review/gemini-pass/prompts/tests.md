## Your pass: tests

Judge whether this diff is tested in a way that will catch it breaking. Ignore logic bugs, security and conventions; three other reviewers own those.

A good test encodes why the behaviour matters, so that changing the business rule breaks the test. A test that only restates the implementation passes forever and protects nothing.

Look for:

- **Untested behaviour that a regression would reach.** New branching logic, a new condition, a new error path, a changed calculation, a new state transition, or a bug fix with no test that reproduces the bug. Say which specific case has no coverage and what would silently break.
- **Tests that cannot fail.** Asserting on a mock's return value rather than on what the code did with it, mocking the unit under test, asserting a component renders without asserting anything about what it rendered, a `try`/`catch` that swallows the assertion, an assertion on a value the test itself just computed the same way the code does.
- **Tests that encode the how instead of the why.** Snapshot tests standing in for behavioural assertions on logic, assertions on internal call counts and orderings that will break on any refactor while missing real breakage, tests named after the function rather than the rule.
- **Existing tests quietly weakened.** An assertion loosened, a case deleted, a test skipped or marked pending, an expectation updated to match new output when the old expectation was the correct one. Check `git diff` for changed test files and say whether the change hides a behaviour change.
- **Missing edge cases the code clearly admits.** Empty collections, absent optional values, the boundary of a range, a timezone or date boundary, a failed request, a concurrent or repeated invocation. Only report the ones the changed code actually handles differently.
- **Tests that will be flaky.** Dependence on the current time or timezone without control, on ordering that is not guaranteed, on a real network or clock, or on state left behind by another test.

Read the test files for the touched code before deciding coverage is missing. If a test command is listed in the context above, run it with those specific test paths appended when you need to see what passes.

Do not ask for tests on trivial or purely presentational changes, and do not ask for coverage of a case the code cannot reach. For each finding, name the behaviour at risk and the failure that would go unnoticed.
