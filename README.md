# LLM Metric 모니터링 시스템

LLM Auth Proxy를 통한 실시간 모니터링 및 알림 시스템

## 🎯 목표

- LLM 요청 통계 데이터 실시간 수집
- Prometheus + Grafana 기반 모니터링
- 자동화된 알림 및 경고 시스템
- 팀/모델/서비스 단위 분석

## 🏗 시스템 구성

```
┌──────────────────────┐
│   LLM Auth Proxy     │  ← 메트릭 수집 대상
│ - /metrics endpoint  │
└─────────▲────────────┘
          │ HTTP (Bearer Token)
┌─────────┴────────────┐
│     Prometheus       │
│ - 메트릭 수집        │
│ - 알림 규칙          │
└─────────▲────────────┘
          │
┌─────────┴────────────┐
│      Grafana         │
│ - 대시보드           │
│ - 알림 관리          │
└──────────────────────┘
```

## 📊 주요 메트릭

- **요청 수**: `llm_requests_total`
- **토큰 사용량**: `llm_tokens_used_total`
- **실패율**: `llm_requests_failed_total`
- **응답 시간**: `llm_response_latency_seconds`
- **비용**: `llm_cost_total`
- **사용자별 사용량**: `llm_user_usage_total`

## 🚀 빠른 시작

```bash
# 1. 환경 설정
cp .env.example .env
# .env 파일에서 설정값 수정

# 2. 시스템 시작
docker-compose up -d

# 3. 접속
# Grafana: http://localhost:3000 (admin/admin)
# Prometheus: http://localhost:9090
```

## 📁 프로젝트 구조

```
├── docker-compose.yml          # 전체 시스템 구성
├── prometheus/
│   ├── prometheus.yml         # Prometheus 설정
│   ├── alert.rules.yml        # 알림 규칙
│   └── llm_admin_token.txt    # 인증 토큰
├── grafana/
│   ├── provisioning/          # 대시보드 자동 설정
│   └── dashboards/           # 커스텀 대시보드
├── llm-auth-proxy/           # 메트릭 제공 서비스
└── scripts/                  # 유틸리티 스크립트
```

## 🔧 설정

### 환경 변수
- `PROMETHEUS_BEARER_TOKEN`: 메트릭 접근 토큰
- `GRAFANA_ADMIN_PASSWORD`: Grafana 관리자 비밀번호
- `SLACK_WEBHOOK_URL`: Slack 알림 웹훅 (선택사항)

### 알림 채널
- Slack
- Discord
- Email
- Webhook

## 📈 대시보드

1. **개요 대시보드**: 전체 시스템 상태
2. **팀별 분석**: 팀별 사용량 및 성능
3. **모델별 분석**: 모델별 성능 비교
4. **비용 분석**: 사용량별 비용 추적
5. **알림 대시보드**: 활성 알림 현황

## 🚨 알림 규칙

- 실패율 20% 초과 시
- 응답 시간 P95 2초 초과 시
- 비용 한도 초과 시
- 이상 패턴 감지 시

## �� 라이센스

MIT License