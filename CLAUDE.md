# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## Project Overview

**PAI (Personal AI Infrastructure)** is an open-source framework for building modular, personalized AI assistant systems. The core innovation is the **PAI Packs** architecture - self-contained capability bundles that work with Claude Code, OpenCode, and other AI coding assistants.

### Key Concepts

- **Packs**: Modular upgrade packages containing complete implementations (Skills, Features, Hooks)
- **Bundles**: Curated collections of packs designed to work together (e.g., Kai Bundle)
- **PAI_DIR**: Environment variable pointing to installation location (defaults to `~/.claude`)
- **DA**: Digital Assistant name - the identity of the AI system

---

## Directory Structure

```
PAI/
├── Packs/                      # Modular capability packs
│   ├── kai-hook-system/        # Event-driven automation framework
│   ├── kai-history-system/     # Automatic context tracking
│   ├── kai-core-install/       # Skill routing & identity
│   ├── kai-voice-system/       # TTS notifications
│   ├── kai-observability-server/ # Real-time monitoring dashboard
│   ├── kai-art-skill/          # Visual content generation
│   ├── kai-agents-skill/       # Dynamic agent composition
│   └── kai-prompting-skill/    # Meta-prompting system
├── Bundles/                    # Curated pack collections
│   └── Kai/                    # Official complete bundle
│       ├── README.md           # Bundle documentation
│       └── install.ts          # Interactive installation wizard
└── Tools/                      # Utilities and templates
    └── PAIPackTemplate.md      # Template for creating new packs
```

---

## Pack Architecture (v2.1.0 Directory-Based Format)

### Pack Structure

Each pack is a **directory** containing:

```
pack-name/
├── README.md          # Overview, architecture, what it solves
├── INSTALL.md         # Step-by-step installation instructions
├── VERIFY.md          # Mandatory verification checklist
└── src/               # Actual source code files (.ts, .yaml, .hbs, etc.)
```

**Key change from v2.0:** Packs are NO LONGER single markdown files. They are directories with real code files that can be linted, tested, and copied directly.

### Why This Matters

1. **Token Limits**: Single-file packs exceeded Claude's 25k token context limit
2. **Code Integrity**: Real files prevent AI "helpful simplification" during installation
3. **Validation**: Code can be linted and tested as actual source files
4. **Clarity**: Clear separation between documentation (README.md) and implementation (src/)

### Installation Pattern

When installing packs, you MUST:
1. Read the complete `INSTALL.md` for step-by-step instructions
2. Copy files from `src/` directory to target locations (usually `$PAI_DIR`)
3. Follow `VERIFY.md` checklist to confirm installation
4. NO simplification or "equivalent" implementations - copy EXACTLY

---

## Common Commands

### Bundle Installation

```bash
# Fresh install with interactive wizard (creates backup)
cd Bundles/Kai
bun run install.ts

# Update existing installation (preserves config)
bun run install.ts --update
```

### Development & Testing

```bash
# Observability dashboard (if installed)
cd $PAI_DIR/observability
./manage.sh status          # Check server status
./manage.sh start           # Start dashboard
./manage.sh stop            # Stop dashboard
./manage.sh restart         # Restart server
./manage.sh dev             # Development mode with watch

# Voice system (if installed)
cd $PAI_DIR/voice
bun run server.ts           # Start voice server manually
```

### Skill Management

```bash
# Generate skill index (if core-install pack installed)
bun $PAI_DIR/tools/GenerateSkillIndex.ts

# Search skills
bun $PAI_DIR/tools/SkillSearch.ts <query>

# Generate architecture documentation
bun $PAI_DIR/tools/PaiArchitecture.ts
```

---

## Architecture Patterns

### The Two Loops Framework

PAI implements a universal pattern for goal pursuit:

1. **Outer Loop**: Current State → Desired State
2. **Inner Loop**: Scientific method in 7 phases
   - OBSERVE → THINK → PLAN → BUILD → EXECUTE → VERIFY → LEARN

Every skill, workflow, and task implements these loops. **Verifiability is critical** - if you can't measure success, you can't improve.

### Hook-Based Event System

PAI uses Claude Code's hook system for event-driven automation:

**Hook Events:**
- `PreToolUse` - Before tool execution (security validation, blocking)
- `PostToolUse` - After tool execution (logging, capture)
- `SessionStart` - New session begins (context loading)
- `SessionEnd` - Session closes (summarization)
- `UserPromptSubmit` - User sends message (input processing)
- `Stop` - Agent finishes responding (capture work)

**Hook Design Principles:**
- Never block (always exit 0)
- Fail silently (errors logged, don't interrupt)
- Fast execution (milliseconds)
- Stdin/stdout communication (JSON in, JSON out)

### Skill System (3-Tier Progressive Disclosure)

1. **TIER 0 (CORE)**: Always loaded at session start
2. **TIER 1 (Frontmatter)**: Skill metadata in system prompt for intent routing
3. **TIER 2 (Full Skill)**: Complete skill loaded when triggered
4. **TIER 3 (Workflow)**: Specific workflow loaded when routed

This minimizes token usage while enabling intelligent capability routing.

---

## Configuration & Environment

### Critical Files

- `$PAI_DIR/.env` - **Single source of truth** for all API keys and configuration
- `$PAI_DIR/settings.json` - Claude Code settings (hooks, skills, identity)
- `$PAI_DIR/PAI Architecture.md` - Auto-generated tracking of installed packs

### Environment Variables

```bash
PAI_DIR           # Installation location (default: ~/.claude)
DA                # Digital Assistant name (e.g., "Kai", "MyAI")
TIME_ZONE         # Timezone for timestamps
REPLICATE_API_TOKEN      # For art generation
ELEVENLABS_API_KEY       # For voice system
GOOGLE_APPLICATION_CREDENTIALS  # For Google Cloud TTS
```

**Security Rule**: NEVER commit `.env` files or hardcode API keys. Always use environment variables.

### Platform Detection

PAI supports macOS and Linux. Use platform-aware code:

```typescript
// TypeScript
if (process.platform === 'darwin') {
  // macOS-specific
} else if (process.platform === 'linux') {
  // Linux-specific
}
```

```bash
# Shell
OS_TYPE="$(uname -s)"
if [ "$OS_TYPE" = "Darwin" ]; then
  # macOS
elif [ "$OS_TYPE" = "Linux" ]; then
  # Linux
fi
```

See `PLATFORM.md` for detailed cross-platform compatibility notes.

---

## Development Workflow

### Creating a New Pack

1. **Use the template**: See existing packs in `Packs/` directory
2. **Follow directory structure**: `README.md`, `INSTALL.md`, `VERIFY.md`, `src/`
3. **Include complete implementation**: No snippets or placeholders
4. **Test installation**: Fresh system test with AI assistance
5. **Sanitize personal data**: Remove hardcoded paths, API keys, names

### Pack Quality Requirements

**Must have:**
- Clear problem statement in README.md
- Complete working code in src/ (not snippets)
- All dependencies documented
- Step-by-step INSTALL.md instructions
- VERIFY.md checklist for validation
- Real examples (not placeholders)
- No hardcoded personal data

**Architecture principles:**
- UNIX Philosophy: Do one thing well
- Code Before Prompts: Use scripts when possible, AI when needed
- As Deterministic as Possible: Consistent patterns and templates
- Spec/Test/Evals First: Define success criteria upfront

### Testing Packs

Each pack includes a VERIFY.md with validation steps. Always run verification after installation:

1. Check all files created
2. Verify hooks registered (if applicable)
3. Run smoke tests
4. Test with clean Claude Code restart

---

## Important Constraints

### Installation Integrity

**CRITICAL**: When installing packs, AI assistants must:
- Copy EVERY file specified
- Include EVERY line of code (no simplification)
- Create COMPLETE implementations (not "equivalent" versions)
- Count files created and verify against spec
- If unable to complete fully, STOP and say so

This is mandatory because AI tends to "helpfully simplify" code during installation, breaking the system.

### Security Patterns

The security-validator hook blocks dangerous operations:

- Database drops
- Uninstalls/removes
- Recursive force deletions
- PAI-specific file modifications (without explicit user permission)

Protected files are tracked in `.pai-protected.json` manifest.

### Path Resolution

All paths use `${PAI_DIR}/` for location-agnostic installations. The system resolves:

1. `process.env.PAI_DIR` (explicit setting)
2. `process.env.PAI_HOME` (legacy/alternate)
3. `~/.claude` (default fallback)

Use centralized path resolution from `pai-paths.ts` library when available.

---

## Code Style Preferences

- **Runtime**: Bun (not Node.js)
- **Languages**: TypeScript (strict mode), Bash for system scripts
- **Indentation**: 2 spaces
- **File naming**: TitleCase for skills/workflows, kebab-case for tools
- **No hardcoded paths**: Always use environment variables
- **Platform-aware**: Detect macOS vs Linux, use appropriate commands

---

## Integration Points

### Claude Code Hooks

Hooks are registered in `$PAI_DIR/settings.json`:

```json
{
  "hooks": [
    {
      "event": "SessionStart",
      "command": "bun",
      "args": ["${PAI_DIR}/hooks/load-core-context.ts"]
    }
  ]
}
```

### Skill Registration

Skills live in `$PAI_DIR/skills/` with structure:

```
skills/
└── SkillName/
    ├── SKILL.md           # Skill definition
    └── Workflows/         # Step-by-step procedures
        └── WorkflowName.md
```

### Observability Integration

Hooks can send events to dashboard via `observability.ts` library:

```typescript
import { notifyObservability } from '../lib/observability.js';

await notifyObservability('session_started', {
  timestamp: new Date().toISOString(),
  session_id: sessionId
});
```

---

## Troubleshooting

### Common Issues

1. **Hooks not firing**: Restart Claude Code after modifying settings.json
2. **PAI_DIR not found**: Check environment variable, defaults to ~/.claude
3. **Platform-specific failures**: Check PLATFORM.md for known issues
4. **Voice system audio**: macOS uses afplay, Linux uses mpg123/mpv
5. **Missing dependencies**: Each pack lists required tools in INSTALL.md

### Verification Pattern

After any pack installation:
1. Read VERIFY.md checklist
2. Check file count matches specification
3. Restart Claude Code
4. Run smoke tests
5. Check hooks fire (if applicable)

---

## Resources

- Main README: Complete PAI overview and philosophy
- PACKS.md: Pack system documentation
- SECURITY.md: Security policies and best practices
- PLATFORM.md: Cross-platform compatibility status
- Individual pack README.md files: Specific pack documentation

---

## Credits

PAI is built by Daniel Miessler and the community. See README.md Credits section for contributors.

**Core Philosophy**: Technology should serve humans. PAI provides open-source scaffolding for building AI systems that know your goals, learn from your history, and get better at helping you over time.
