# LLM Monitoring System 설정 가이드

## 🚀 빠른 시작

### 1. 사전 요구사항

- Docker 및 Docker Compose 설치
- LLM Auth Proxy가 `/metrics` 엔드포인트를 제공
- Bearer Token 인증 지원

### 2. 초기 설정

```bash
# 1. 저장소 클론
git clone <repository-url>
cd llm-monitoring-system

# 2. 설정 스크립트 실행
chmod +x scripts/setup.sh
./scripts/setup.sh

# 3. 환경 변수 설정
cp env.example .env
# .env 파일을 편집하여 실제 값 입력
```

### 3. 환경 변수 설정

`.env` 파일에서 다음 값들을 설정하세요:

```bash
# Prometheus 설정
PROMETHEUS_BEARER_TOKEN=your_secure_token_here

# Grafana 설정
GRAFANA_ADMIN_PASSWORD=your_secure_password

# 알림 설정 (선택사항)
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK
DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/YOUR/DISCORD/WEBHOOK
```

### 4. LLM Auth Proxy 설정

`prometheus/prometheus.yml` 파일에서 LLM Auth Proxy 주소를 설정하세요:

```yaml
scrape_configs:
  - job_name: 'llm-auth-proxy'
    static_configs:
      - targets: ['your-llm-auth-proxy-host:8000']  # 실제 주소로 변경
```

### 5. 시스템 시작

```bash
# 시스템 시작
docker-compose up -d

# 상태 확인
./scripts/health-check.sh
```

## 📊 접속 정보

| 서비스 | URL | 기본 계정 |
|--------|-----|-----------|
| Grafana | http://localhost:3000 | admin/admin123 |
| Prometheus | http://localhost:9090 | - |
| Alertmanager | http://localhost:9093 | - |

## 📈 주요 메트릭

### 기본 메트릭
- `llm_requests_total`: 총 요청 수
- `llm_tokens_used_total`: 사용된 토큰 수
- `llm_requests_failed_total`: 실패한 요청 수
- `llm_response_latency_seconds`: 응답 시간

### 파생 지표
- **실패율**: `rate(llm_requests_failed_total[5m]) / rate(llm_requests_total[5m])`
- **응답 시간 P95**: `histogram_quantile(0.95, rate(llm_response_latency_seconds_bucket[5m]))`
- **토큰 효율성**: `rate(llm_tokens_used_total[5m]) / rate(llm_requests_total[5m])`

## 🚨 알림 규칙

### 주요 알림
1. **실패율 급증**: 20% 초과 시
2. **응답 지연**: P95 2초 초과 시
3. **요청 수 급증**: 3배 이상 증가 시
4. **토큰 사용량 급증**: 5배 이상 증가 시

### 알림 채널 설정
Alertmanager에서 다음 채널들을 설정할 수 있습니다:
- Email
- Webhook

## 📋 유지보수

### 정기 백업
```bash
# 백업 실행
./scripts/backup.sh

# 백업 복원 (필요시)
tar -xzf backups/llm_monitoring_backup_YYYYMMDD_HHMMSS_full.tar.gz
```

### 로그 확인
```bash
# 전체 로그
docker-compose logs

# 특정 서비스 로그
docker-compose logs prometheus
docker-compose logs grafana
docker-compose logs alertmanager
```

### 시스템 업데이트
```bash
# 서비스 중지
docker-compose down

# 이미지 업데이트
docker-compose pull

# 서비스 재시작
docker-compose up -d
```

## 🔧 문제 해결

### 일반적인 문제

1. **Prometheus가 메트릭을 수집하지 못함**
   - LLM Auth Proxy 주소 확인
   - Bearer Token 설정 확인
   - 네트워크 연결 확인

2. **Grafana에서 데이터가 보이지 않음**
   - Prometheus 데이터소스 설정 확인
   - 시간 범위 설정 확인

3. **알림이 발송되지 않음**
   - Alertmanager 설정 확인
   - 알림 채널 설정 확인

### 디버깅 명령어
```bash
# 서비스 상태 확인
./scripts/health-check.sh

# Prometheus 타겟 상태 확인
curl http://localhost:9090/api/v1/targets

# 알림 상태 확인
curl http://localhost:9093/api/v1/alerts
```

## 📚 추가 리소스

- [Prometheus 공식 문서](https://prometheus.io/docs/)
- [Grafana 공식 문서](https://grafana.com/docs/)
- [Alertmanager 공식 문서](https://prometheus.io/docs/alerting/latest/alertmanager/)

## 🤝 지원

문제가 발생하거나 질문이 있으시면:
1. 이슈 트래커에 등록
2. 로그 파일 확인
3. 시스템 상태 스크립트 실행 결과 공유 