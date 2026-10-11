# Changelog

All notable changes to Workspace Manager Skill will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-09-23

### Added
- **One-command initialization**: `/py-workspace init` creates complete workspace structure
- **Smart file classification**: Recognizes user habits and identifies content automatically
- **Auto-generated navigation**: SOURCE_OF_TRUTH.md with quick-find table and directory responsibilities
- **Auto-generated rules**: AGENTS.md with read protocols and version conflict handling
- **Daily work log**: Automatic date-based logging with history preservation
- **Safe file exchange**: Upload zone (temporary) and download zone (backup)
- **Cross-window context**: Agent reads history to continue work in new windows
- **Rule negotiation**: Dialog-based priority and citation rules setup
- **Complete documentation**: README, QUICKSTART, examples, and development guide
- **MIT License**: Open source and ready for community contributions

### Core Files
- `SKILL.md` (586 lines): Main skill implementation
- `README.md`: User documentation with FAQ and comparison table
- `QUICKSTART.md`: 5-minute quick start guide
- `templates/`: SOURCE_OF_TRUTH.md and AGENTS.md templates
- `examples/`: Consultant example with full workflow
- `docs/DEVELOPMENT.md`: Technical implementation details

### Design Philosophy
- Dialog-guided over fixed templates
- Move files instead of copy (avoid version confusion)
- Negotiate confirmation over auto-decision
- Minimal startup over feature-complete

### Tested Scenarios
- Consultant managing multiple client projects
- Course creator organizing teaching materials
- Service providers with mixed content types

[1.0.0]: https://github.com/bf66bf-ai/py-workspace-skill/releases/tag/v1.0.0
