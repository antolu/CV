# CLAUDE.md

This file provides guidance to an LLM when working with code in this repository.

## Commands

RenderCV runs via Docker:

```bash
# Render (produces PDF, Typst, Markdown, HTML, PNG)
docker run --rm -v "$PWD":/work -u $(id -u):$(id -g) -e HOME=/tmp -w /work ghcr.io/rendercv/rendercv render Anton_Lu_CV.yaml

# Watch mode — auto-rerenders on save
docker run --rm -v "$PWD":/work -u $(id -u):$(id -g) -e HOME=/tmp -w /work ghcr.io/rendercv/rendercv render Anton_Lu_CV.yaml --watch

# Quick preview (PNG only, no PDF)
docker run --rm -v "$PWD":/work -u $(id -u):$(id -g) -e HOME=/tmp -w /work ghcr.io/rendercv/rendercv render Anton_Lu_CV.yaml --dont-generate-pdf --dont-generate-html --dont-generate-markdown

# Scaffold a new YAML file
docker run --rm -v "$PWD":/work -u $(id -u):$(id -g) -e HOME=/tmp -w /work ghcr.io/rendercv/rendercv new "Your Name"
```

## YAML structure

The file has four top-level keys: `cv`, `design`, `locale`, `settings`. Only `cv` is required.

`cv.sections` is a dict of `section_title → list[entries]`. Section keys in `snake_case` auto-capitalise (`non_profit_work` → "Non Profit Work"). All entries in a section must be the same type — type is auto-detected from fields present.

### Entry types

| Type                                      | Required fields              | Notes                                             |
| ----------------------------------------- | ---------------------------- | ------------------------------------------------- |
| `ExperienceEntry`                         | `company`, `position`        | Jobs                                              |
| `EducationEntry`                          | `institution`, `area`        | `degree` optional                                 |
| `NormalEntry`                             | `name`                       | Projects, awards                                  |
| `PublicationEntry`                        | `title`, `authors`           | Use `*Name*` to italicise the CV owner in authors |
| `OneLineEntry`                            | `label`, `details`           | Skills, languages                                 |
| `BulletEntry`                             | `bullet`                     | Simple bullets                                    |
| `NumberedEntry` / `ReversedNumberedEntry` | `number` / `reversed_number` | Numbered lists                                    |
| `TextEntry`                               | plain string                 | Free-form paragraphs                              |

Shared fields on complex entries: `date`, `start_date`, `end_date`, `location`, `summary`, `highlights`.

- `date` and `start_date`/`end_date` are mutually exclusive.
- `start_date`/`end_date` require strict format: YYYY-MM-DD, YYYY-MM, or YYYY. `"present"` is a valid `end_date`.
- Omitting `end_date` when `start_date` is set defaults to `"present"`.

### Common pitfalls

- **Quote any string value containing `:`** — colons break YAML parsing. Always quote highlights, titles, and summaries that contain colons.
- Phone numbers must be E.164 international format: `"+46707440050"`.
- `design.highlights.bullet` only accepts: `●`, `•`, `◦`, `-`, `◆`, `★`, `■`, `—`, `○`.
- Inline Markdown (`**bold**`, `*italic*`, `[text](url)`) works everywhere; block-level Markdown does not.
- Typos in field names are silently ignored — no validation error, the field just disappears.

## Themes

Available: `classic`, `harvard`, `engineeringresumes`, `engineeringclassic`, `sb2nov`, `moderncv`.

Override any design field after setting `design.theme`. Key customisation points: `design.colors`, `design.typography.font_family`, `design.section_titles.type`, `design.entries`, `design.templates`.

## JSON schema (editor autocompletion)

Add this as the first line of the YAML file:

```yaml
# yaml-language-server: $schema=https://raw.githubusercontent.com/rendercv/rendercv/refs/tags/v2.8/schema.json
```

## Skill

Use the /rendercv skill if available to gain insight into available keys and document structure without looking into documentation or source code
