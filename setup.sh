#!/bin/bash
set -e

curl -fsSL https://pi.dev/install.sh | sh || {
	echo "Please say yes to installing Pi!"
	exit 1
}

curl -fsSL https://astral.sh/uv/install.sh | sh || {
	echo "Please say yes to installing uv!"
	exit 1
}

. ~/.zshrc

uvx alcf-ai auth login

mkdir -p ~/.pi/agent
cat > ~/.pi/agent/models.json << 'EOF'
{
  "providers": {
    "alcf-minerva": {
      "baseUrl": "https://inference-api.alcf.anl.gov/resource_server/minerva/api/v1",
      "api": "openai-completions",
      "apiKey": "!uvx alcf-ai auth get-access-token",
      "compat": {
        "supportsDeveloperRole": false,
        "supportsReasoningEffort": false
      },
      "models": [{ "id": "inkling-bf16" }, {"id": "nemotron-3-ultra"}]
    }
  }
}
EOF

echo "Done! You can start the agent with \`pi\`"
