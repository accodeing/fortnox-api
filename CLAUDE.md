# CLAUDE.md

Project guidance for Claude Code. Keep entries terse and high-signal.

## Changelog

`CHANGELOG.md` follows [Keep a Changelog](https://keepachangelog.com/)
and Semantic Versioning. Conventions:

- New, unreleased changes go under a `## [Unreleased]` heading.
- Only consumer-facing gem changes are logged. Documentation,
  CI/tooling, and internal refactors are not.
- Every bracketed version heading must have a matching reference-link
  definition at the bottom of the file:
  `[<VERSION>]: …/compare/v<PREVIOUS>...v<VERSION>`, and `[Unreleased]`
  points at `…/compare/v<LATEST>...HEAD`. Never add or rename a version
  heading without adding/repointing its compare link.
- When a bug was introduced by the 1.0 rest-easy rewrite (rc1) and did
  not exist in 0.x, say so explicitly in the entry (existing precedent
  in the file).

The full release procedure is in
[DEVELOPER_README.md](DEVELOPER_README.md#release-process).

## VCR cassettes

Integration specs record real Fortnox sandbox traffic with VCR
(`spec/vcr_cassettes/`). Rules:

- Never hand-edit a cassette. When the expected request or response
  changes, delete the cassette file and re-record by running the
  affected spec.
- Recording needs a valid `FORTNOX_ACCESS_TOKEN` in `.env.test.local`
  (gitignored). Tokens are short-lived — on a 401, refresh with
  `bundle exec ruby bin/fortnox-update-env .env.test.local`, then
  re-run the spec.
- A failed recording run still writes a cassette (e.g. with the 401
  response in it), and the next run replays that failure. Delete the
  bad cassette before retrying.
- Re-record one resource spec file at a time — running many against
  the live API trips Fortnox rate limiting (429).

## Releasing

Use the rake tasks — do not run the steps by hand:

```shell
bundle exec rake release:prepare VERSION=<VERSION>   # bumps version, edits CHANGELOG, commits, tags
bundle exec rake release:publish VERSION=<VERSION>   # gem build/push, git push --tags
```

`release:prepare` won't run if `[Unreleased]` is empty, so make sure
the changelog is up to date first.
