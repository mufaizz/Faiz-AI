#!/bin/bash
set -e

echo "FAIZ AI - Complete System Setup"
echo "================================"

# Update system
sudo apt-get update -y

# Install Python and essentials
sudo apt-get install -y python3 python3-pip python3-venv curl

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install --upgrade pip

# Use requirements.txt if it exists, otherwise fall back to manual install
if [ -f "requirements.txt" ]; then
    echo "📦 Installing from requirements.txt..."
    pip install -r requirements.txt
else
    echo "⚠️ requirements.txt not found! Installing manually..."
    pip install sentence-transformers==2.2.2 aiohttp==3.9.1 aioftp==0.21.3 \
    pyspellchecker==0.7.2 pyyaml==6.0.1 numpy==1.24.3 bencodepy pyppeteer
fi

# Create config directory
mkdir -p config

# Only create config.yaml if it DOES NOT exist
if [ ! -f "config/config.yaml" ]; then
    echo "⚙️ Creating default config.yaml..."
    cat > config/config.yaml << 'EOF'
core:
  model: "all-MiniLM-L6-v2"
  embedding_dim: 384

search:
  timeout: 45
  max_results: 100
  filetypes: ["pdf", "doc", "docx", "zip", "mp4", "mp3"]
  protocols: ["http", "ftp", "ipfs", "torrent"]

safety:
  enable_verification: true
  max_file_size_mb: 500
  blocked_extensions: [".exe", ".bat", ".sh", ".dmg"]

http:
  user_agent: "Mozilla/5.0 (FAIZ-AI/1.0)"
  rate_limit_delay: 1.0

ftp:
  public_servers:
    - "ftp.freebsd.org"
    - "speedtest.tele2.net"
    - "ftp.ncbi.nlm.nih.gov"
    - "mirrors.kernel.org"
EOF
else
    echo "✅ Existing config.yaml found. Keeping your custom settings."
fi

# Set Python path
echo "export PYTHONPATH=\$PYTHONPATH:$(pwd)" >> ~/.bashrc

echo ""
echo "✅ FAIZ AI Setup Complete!"
echo ""
echo "To use:"
echo "1. source venv/bin/activate"
echo "2. python main.py"
echo ""
echo "Example:"
echo "python main.py"
