# 🎙️ Science Fair Presentation Analyzer

AI-powered analysis of science fair presentations with **>80% accuracy target** for overall assessment.

## 🎯 What It Analyzes

| Dimension | Weight | Metrics |
|-----------|--------|---------|
| **Speech Delivery** | 40% | Fluency, Prosody, Pronunciation |
| **Content Structure** | 60% | Organization, Clarity, Completeness, Engagement, Scientific Rigor |

## 🏗️ Architecture

```
Audio Input
    │
    ▼
┌─────────────────────────────────────┐
│  Whisper Large-v3 (LoRA fine-tuned) │ ──▶ Transcript
│  Trained on: TED-LIUM, SPGI,        │
│  LibriSpeech, Common Voice          │
└─────────────────────────────────────┘
    │
    ├──────────────────┬──────────────────┐
    ▼                  ▼                  ▼
┌─────────────┐  ┌─────────────┐  ┌─────────────┐
│  Prosody    │  │  Fluency    │  │ Pronunciation│
│  (eGeMAPS)  │  │  (XGBoost)  │  │  (Ensemble)  │
└─────────────┘  └─────────────┘  └─────────────┘
    │                  │                  │
    └──────────────────┼──────────────────┘
                       ▼
            ┌─────────────────────┐
            │   Speech Score      │ (40%)
            └─────────────────────┘
                       │
                       ▼
            ┌─────────────────────┐
            │   Content Score     │ (60%) ──▶ LLM (Gemini/Claude)
            └─────────────────────┘
                       │
                       ▼
            ┌─────────────────────┐
            │  Overall Score      │
            │  + Detailed Report  │
            └─────────────────────┘
```

## 🚀 Quick Start: Google Colab

### Option 1: Run All Notebooks in Sequence

1. **Open each notebook in Colab:**
   - [01_data_preparation.ipynb](notebooks/01_data_preparation.ipynb)
   - [02_whisper_finetune.ipynb](notebooks/02_whisper_finetune.ipynb)
   - [03_prosody_fluency.ipynb](notebooks/03_prosody_fluency.ipynb)
   - [04_content_scoring.ipynb](notebooks/04_content_scoring.ipynb)
   - [05_integration_evaluation.ipynb](notebooks/05_integration_evaluation.ipynb)

2. **Enable GPU:** Runtime → Change runtime type → T4 GPU (or A100)

3. **Add API Keys** (for content scoring):
   - Click 🔑 (key icon) in left sidebar
   - Add `GEMINI_API_KEY` and/or `ANTHROPIC_API_KEY`

4. **Run cells top to bottom**

### Option 2: Use Pre-trained Models

Download models from Hugging Face (coming soon) and run only Notebook 5.

## 📊 Expected Performance

| Metric | Target | Notes |
|--------|--------|-------|
| ASR WER | < 8% | On presentation/academic speech |
| Fluency correlation | > 0.85 | vs human raters |
| Prosody correlation | > 0.80 | vs human raters |
| **Overall accuracy** | **> 80%** | Weighted ensemble |

## 🐳 Deployment

### Hugging Face Spaces (Gradio)

```bash
# Push to HF Spaces
git clone https://huggingface.co/spaces/your-username/presentation-analyzer
cp deployment/gradio_app.py app.py
cp deployment/requirements.txt requirements.txt
# Add models to repo or download at startup
git push
```

### Google Cloud Run (FastAPI)

```bash
# Build and deploy
gcloud builds submit --tag gcr.io/PROJECT_ID/presentation-analyzer
gcloud run deploy presentation-analyzer \
  --image gcr.io/PROJECT_ID/presentation-analyzer \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --memory 4Gi \
  --cpu 2 \
  --timeout 300
```

### Local Development

```bash
# Install
pip install -r deployment/requirements.txt

# Run API
MODEL_DIR=/path/to/models python deployment/fastapi_app.py

# Test
curl -X POST -F "file=@presentation.wav" http://localhost:8080/analyze
```

## 📁 Project Structure

```
speech_analyzer/
├── notebooks/
│   ├── 01_data_preparation.ipynb      # Download & process datasets
│   ├── 02_whisper_finetune.ipynb      # LoRA fine-tune Whisper
│   ├── 03_prosody_fluency.ipynb       # Train prosody/fluency models
│   ├── 04_content_scoring.ipynb       # LLM content analysis
│   └── 05_integration_evaluation.ipynb # Combine & evaluate
├── deployment/
│   ├── gradio_app.py                  # HF Spaces UI
│   ├── fastapi_app.py                 # Cloud Run API
│   ├── Dockerfile                     # Container for Cloud Run
│   └── requirements.txt               # Python dependencies
├── configs/
│   ├── content_rubric.json            # Science fair rubric
│   └── required_elements.json         # Required presentation elements
└── models/                            # Generated (not in repo)
    ├── whisper_large_v3_lora/         # Fine-tuned Whisper
    ├── prosody_fluency/               # Speech delivery models
    └── presentation_analyzer.pkl      # Unified pipeline
```

## 🔧 Configuration

### Science Fair Rubric (`configs/content_rubric.json`)

Customize weights and criteria for your specific competition:

```json
{
  "scientific_rigor": { "weight": 0.30, ... },
  "organization": { "weight": 0.20, ... },
  "clarity": { "weight": 0.20, ... },
  "engagement": { "weight": 0.15, ... },
  "completeness": { "weight": 0.15, ... }
}
```

### Model Weights

Adjust speech vs content balance in `notebooks/05_integration_evaluation.ipynb`:

```python
# Default: 40% speech, 60% content
overall = 0.4 * speech_score + 0.6 * content_score
```

## 📈 Improving Accuracy

1. **Collect real data**: Record 200+ science fair presentations with expert ratings
2. **Retrain prosody models**: Replace synthetic labels with human scores
3. **Fine-tune content LLM**: Few-shot prompt with annotated examples
4. **Add speaker diarization**: For multi-presenter projects
5. **Domain adaptation**: Add more technical vocabulary data

## 💰 Cost Estimate (Colab)

| Step | GPU Time | Est. Cost (Colab Pro) |
|------|----------|----------------------|
| Data prep | 10 min | Free |
| Whisper LoRA | 2-3 hours | ~$2-3 |
| Prosody training | 15 min | Free |
| Content scoring | API calls | ~$0.01/presentation |
| **Total** | **~3 hours** | **~$3-5** |

## 🔑 API Keys Needed

| Service | Purpose | Free Tier |
|---------|---------|-----------|
| Google Gemini | Content scoring | 60 req/min |
| Anthropic Claude | Content scoring | $5 free credit |
| Hugging Face | Model hosting | Free |

## 📝 License

MIT License - Feel free to use for science fair projects!

## 🤝 Contributing

1. Fork the repo
2. Add your improvements
3. Submit PR with benchmarks

## 📞 Support

- Issues: GitHub Issues
- Questions: Discussions tab
- Email: markemad485@gmail.com

---

**Built for science fair participants who want to improve their presentation skills.**
