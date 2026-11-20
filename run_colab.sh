#!/bin/bash
# Quick setup script for Google Colab
# Run this in a Colab cell: !bash run_colab.sh

set -e

echo "🚀 Setting up Science Fair Presentation Analyzer..."

# Install system dependencies
apt-get update -qq && apt-get install -y -qq ffmpeg libsndfile1 2>/dev/null

# Install Python packages
pip install -q \
    datasets==2.18.0 \
    huggingface_hub==0.22.2 \
    librosa==0.10.2 \
    torchaudio==2.3.0 \
    torch==2.2.0 \
    transformers==4.39.0 \
    accelerate==0.29.0 \
    jiwer==3.0.4 \
    peft==0.10.0 \
    evaluate==0.4.1 \
    wandb==0.17.0 \
    opensmile==3.0.2 \
    xgboost==2.0.3 \
    lightgbm==4.3.0 \
    scikit-learn==1.3.2 \
    pandas==2.1.4 \
    joblib==1.3.2 \
    google-generativeai==0.7.0 \
    anthropic==0.25.0 \
    tenacity==8.2.3 \
    soundfile==0.12.1 \
    gradio==4.25.0 \
    fastapi==0.109.0 \
    uvicorn==0.27.0

# Create directories
mkdir -p /content/speech_analyzer/{data/processed,models,configs,deployment,notebooks}

echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Upload notebooks to /content/speech_analyzer/notebooks/"
echo "2. Run 01_data_preparation.ipynb first"
echo "3. Add GEMINI_API_KEY and ANTHROPIC_API_KEY to Colab secrets (🔑 icon)"
echo "4. Run notebooks in order: 01 → 02 → 03 → 04 → 05"