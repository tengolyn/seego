#!/bin/bash
set -e

echo "Initializing Seego Agentic Environment..."

if [ ! -d "bootstrapping" ] || [ ! -d "architecture" ]; then
  echo "Error: Please run this script from the root of the repository."
  exit 1
fi

if [ -d ".agents" ] || [ -d ".agents_memory" ]; then
  echo "Warning: .agents or .agents_memory already exists. Proceeding with caution to avoid overwriting existing data..."
fi

# 1. Scaffold directories
echo "Scaffolding directories..."
mkdir -p .agents/skills .agents/agents \
  .agents_memory/passive_memory/draft \
  .agents_memory/passive_memory/current \
  .agents_memory/passive_memory/archived

# 2. Touch memory files
echo "Initializing memory files..."
touch .agents_memory/active_memory.md .agents_memory/scratchpad.md

# 3. Copy AGENTS.md template to root
if [ ! -f "AGENTS.md" ]; then
    echo "Creating AGENTS.md router..."
    cp bootstrapping/AGENTS_template.md AGENTS.md
else
    echo "AGENTS.md already exists, skipping."
fi

echo "Scaffolding complete. The AI assistant should now proceed with seeding meta-skills and the master plan."
