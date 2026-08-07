#!/bin/sh

curl -fsSL https://pi.dev/install.sh | sh

mkdir -p ~/.local/bin
curl -fsSL https://raw.githubusercontent.com/argonne-lcf/inference-endpoints/refs/heads/main/inference_auth_token.sh > ~/.local/bin/inference_auth_token.sh
chmod u+x ~/.local/bin/inference_auth_token.sh

. ~/.zshrc

inference_auth_token.sh authenticate < /dev/tty

mkdir -p ~/.pi/agent
cat > ~/.pi/agent/models.json << 'EOF'
{
  "providers": {
    "alcf-minerva": {
      "baseUrl": "https://inference-api.alcf.anl.gov/resource_server/minerva/api/v1",
      "api": "openai-completions",
      "apiKey": "!inference_auth_token.sh get_access_token",
      "compat": {
        "supportsDeveloperRole": false,
        "supportsReasoningEffort": false
      },
      "models": [{ "id": "inkling-bf16", "contextWindow": 262144 }, {"id": "nemotron-3-ultra", "contextWindow": 131072 }]
    }
  }
}
EOF

echo "Done! You can start the agent with \`pi\`"
