# Creole Platform Deployment Templates

This repository contains deployment templates and configuration files for the Creole Translation Platform - a comprehensive microservices architecture for Haitian Creole language processing.

## Architecture Overview

The Creole Platform consists of the following services:

- **Translation Service** (`localhost:8001`) - REST API for text translation
- **Speech-to-Text Service** (`localhost:8002`) - Audio transcription with WebSocket streaming
- **Text-to-Speech Service** (`localhost:8003`) - Speech synthesis from text
- **Web Application** (`localhost:3000`) - React-based user interface
- **Redis** (`localhost:6379`) - Caching and session storage
- **Nginx** (`localhost:80`) - Reverse proxy and load balancing

## Quick Start

### Prerequisites

- Docker and Docker Compose
- Git
- Node.js (for SDK development)
- Python 3.8+ (for SDK development)

### Deploy the Platform

1. **Clone all repositories:**
   ```bash
   git clone https://github.com/YOUR_ORG/creole-platform-setup-31364.git
   cd creole-platform-setup-31364
   ```

2. **Start the entire platform:**
   ```bash
   cd deployment-templates
   docker-compose up -d
   ```

3. **Check service health:**
   ```bash
   curl http://localhost:8001/health  # Translation service
   curl http://localhost:8002/health  # Speech-to-Text service
   curl http://localhost:8003/health  # Text-to-Speech service
   ```

4. **Access the web interface:**
   Open http://localhost:3000 in your browser

## Service Details

### Translation Service (Port 8001)
- **Endpoints:**
  - `POST /api/v1/translate` - Single text translation
  - `POST /api/v1/translate/batch` - Batch translation to multiple languages
  - `GET /api/v1/languages` - List supported languages
  - `GET /health` - Service health check

### Speech-to-Text Service (Port 8002)
- **Endpoints:**
  - `POST /api/v1/transcribe` - Upload audio file for transcription
  - `POST /api/v1/detect-language` - Detect language from audio
  - `WS /api/v1/stream` - WebSocket streaming transcription
  - `GET /health` - Service health check

### Text-to-Speech Service (Port 8003)
- **Endpoints:**
  - `POST /api/v1/synthesize` - Generate speech from text
  - `GET /api/v1/voices` - List available voices
  - `POST /api/v1/preview` - Preview voice with sample text
  - `GET /health` - Service health check

## Development Setup

### Individual Service Development

Each service can be developed independently:

```bash
# Translation Service
cd translation-service
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8001

# Speech-to-Text Service
cd speech-to-text-service
pip install -r requirements.txt
uvicorn main:app --reload --port 8002

# Text-to-Speech Service
cd text-to-speech-service
pip install -r requirements.txt
uvicorn main:app --reload --port 8003

# Web Application
cd creole-translator-web
npm install
npm run dev
```

### SDK Development

**JavaScript/TypeScript SDK:**
```bash
cd platform-sdk-js
npm install
npm run build
```

**Python SDK:**
```bash
cd platform-sdk-python
pip install -r requirements.txt
python -m pytest tests/
```

## Configuration

### Environment Variables

Create a `.env` file in the deployment-templates directory:

```env
# Service URLs
TRANSLATION_SERVICE_URL=http://translation-service:8001
STT_SERVICE_URL=http://stt-service:8002
TTS_SERVICE_URL=http://tts-service:8003

# Redis Configuration
REDIS_URL=redis://redis:6379

# Development settings
DEBUG=true
LOG_LEVEL=INFO

# Production settings (comment out for development)
# CORS_ORIGINS=https://your-domain.com
# SSL_CERT_PATH=/path/to/cert.pem
# SSL_KEY_PATH=/path/to/key.pem
```

### Docker Compose Profiles

The `docker-compose.yml` supports different deployment profiles:

**Development (default):**
```bash
docker-compose up -d
```

**Production:**
```bash
docker-compose --profile production up -d
```

**Services only (without web app):**
```bash
docker-compose --profile services up -d
```

## API Usage Examples

### Translation
```bash
curl -X POST http://localhost:8001/api/v1/translate \
  -H "Content-Type: application/json" \
  -d '{
    "text": "Hello, how are you?",
    "source_language": "en",
    "target_language": "ht"
  }'
```

### Speech-to-Text
```bash
curl -X POST http://localhost:8002/api/v1/transcribe \
  -F "file=@audio.wav" \
  -F "language=ht"
```

### Text-to-Speech
```bash
curl -X POST http://localhost:8003/api/v1/synthesize \
  -H "Content-Type: application/json" \
  -d '{
    "text": "Bonjou, koman ou ye?",
    "language": "ht",
    "voice": "default"
  }' \
  --output speech.wav
```

## SDK Usage

### JavaScript/TypeScript SDK
```javascript
import { CreolePlatformSDK } from 'creole-platform-sdk';

const sdk = new CreolePlatformSDK({
  translationUrl: 'http://localhost:8001',
  sttUrl: 'http://localhost:8002',
  ttsUrl: 'http://localhost:8003'
});

// Translation
const result = await sdk.translate({
  text: 'Hello world',
  from: 'en',
  to: 'ht'
});

// Speech synthesis
const audioBlob = await sdk.synthesizeText('Bonjou!', {
  language: 'ht',
  voice: 'default'
});
```

### Python SDK
```python
import asyncio
from creole_platform_sdk import CreolePlatformSDK, TranslationOptions

async def main():
    async with CreolePlatformSDK() as sdk:
        # Translation
        result = await sdk.translate(TranslationOptions(
            text="Hello world",
            source_language="en",
            target_language="ht"
        ))
        
        # Speech synthesis
        audio_data = await sdk.synthesize_text("Bonjou!")

if __name__ == "__main__":
    asyncio.run(main())
```

## Monitoring and Logging

### Health Checks

All services provide health endpoints:
- Translation: `GET /health`
- Speech-to-Text: `GET /health`
- Text-to-Speech: `GET /health`

### Service Monitoring

Use Docker's built-in monitoring:
```bash
docker-compose ps
docker-compose logs -f [service-name]
```

### Performance Metrics

Services expose metrics at `/metrics` endpoint (Prometheus format):
```bash
curl http://localhost:8001/metrics
```

## Deployment

### Production Deployment

1. **Update environment variables** for production
2. **Configure SSL certificates** in nginx.conf
3. **Set up proper secrets management**
4. **Configure monitoring and alerting**
5. **Set up CI/CD pipeline**

### Kubernetes Deployment

Kubernetes manifests are available in the `k8s/` directory:

```bash
kubectl apply -f k8s/
```

### Cloud Deployment

Each service includes cloud deployment configurations:
- AWS ECS/EKS
- Google Cloud Run/GKE
- Azure Container Instances/AKS

## Security Considerations

- **API Authentication**: Implement JWT or API key authentication
- **Rate Limiting**: Configure rate limiting in nginx
- **Input Validation**: All inputs are validated and sanitized
- **CORS**: Configure CORS policies for web applications
- **SSL/TLS**: Use HTTPS in production
- **Secrets Management**: Use proper secret management (AWS Secrets Manager, etc.)

## Troubleshooting

### Common Issues

1. **Service not starting:**
   ```bash
   docker-compose logs [service-name]
   ```

2. **Connection refused errors:**
   - Check if services are running: `docker-compose ps`
   - Verify network connectivity: `docker network ls`

3. **Port conflicts:**
   - Update ports in docker-compose.yml if needed
   - Check for conflicting services: `lsof -i :8001`

### Debug Mode

Enable debug mode for detailed logging:
```bash
docker-compose -f docker-compose.yml -f docker-compose.debug.yml up -d
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Run linting and tests
6. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:
- Create an issue in the GitHub repository
- Check the documentation wiki
- Join our community Discord server
