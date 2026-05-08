# Jira Integration — Rulebook

Quy tắc và hướng dẫn để AI agent làm việc đúng cách với Jira Server / Data Center.
Source connector: `app/connectors/jira.py` trong `ict-ai-context-engine`.

---

## 1. Cấu hình

```env
AI_CONTEXT_V2_JIRA_BASE_URL=https://jira.company.com
AI_CONTEXT_V2_JIRA_TOKEN=<personal-access-token>
AI_CONTEXT_V2_JIRA_PROJECT_KEYS=PROJ,OMS
AI_CONTEXT_V2_JIRA_QUALITY_THRESHOLD=0.7
AI_CONTEXT_V2_JIRA_CONNECT_TIMEOUT=5.0
AI_CONTEXT_V2_JIRA_READ_TIMEOUT=30.0
AI_CONTEXT_V2_JIRA_MAX_POOL_SIZE=10
```

---

## 2. Đăng ký connector

```bash
python -m app.cli bootstrap          # tự động từ .env
python -m app.cli list-connectors    # kiểm tra
```

---

## 3. Pull Jira issues → ChromaDB

```bash
python -m app.cli jira-sync
python -m app.cli jira-sync --project-key PROJ
python -m app.cli jira-sync --project-key PROJ --project-key OMS
```

**Lưu ý:** Upsert theo `issue_key` — idempotent. PII tự động bị mask.

---

## 4. Tạo Epic → Story → Sub-task từ intent

```bash
python -m app.cli jira-create "Mô tả tính năng..." --project-key PAYMENT
```

Cấu trúc ticket:
```
Epic: [Epic] <intent>
  └── Story: <intent>
        ├── Sub-task: [Analysis] Phân tích và thiết kế
        ├── Sub-task: [Dev] Implement
        └── Sub-task: [Test] Kiểm thử
```

### Quality Gate bắt buộc

| Tiêu chí | Khi fail |
|---|---|
| Summary không rỗng | Score = 0.0, từ chối |
| Description ≥ 50 ký tự | Trừ điểm |
| Có acceptance criteria (Story) | Trừ điểm |
| Có business objective (Epic) | Trừ điểm |
| Không có TODO/TBD placeholder | Trừ điểm |
| Có security note (auth/payment) | Trừ điểm |

Ngưỡng mặc định: `0.7`. Score < ngưỡng → từ chối, trả về danh sách vấn đề.

---

## 5. Sinh task brief từ Jira ticket

```bash
python -m app.cli jira-brief PROJ-123
python -m app.cli jira-brief PROJ-123 --collection knowledge --top-k 10
```

Brief bao gồm: Jira context + Confluence business rules + GitLab technical context.
Data freshness: `live` — pull trực tiếp từ Jira API, không chỉ từ ChromaDB.

---

## 6. Sync dossier status → Jira

| Dossier status | Jira transition |
|---|---|
| `started` / `planned` | In Progress |
| `completed` | Done |
| `blocked` | Blocked |

Liên kết dossier với ticket:
```bash
curl -X POST http://localhost:8100/api/jira/link-dossier \
  -d '{"task_id": "task-20240115-...", "issue_key": "PROJ-123"}'
```

---

## 7. Workflow cho C# Feature (trong harness)

```
1. jira-brief <ISSUE-KEY>
2. Tạo ticket trong thoughts/shared/01-tickets/
3. Tạo plan trong thoughts/shared/03-plans/
4. Tạo prompt-spec.md
5. Tạo branch GitLab: features/{dev}-{ISSUE-KEY}-{slug}
6. Implement theo ABP VSA pattern
7. Cập nhật dossier status → auto-sync sang Jira
8. Push branch + tạo MR GitLab
9. Publish spec lên Confluence nếu cần
```

---

## 8. Quy tắc bắt buộc

1. **Không tạo ticket khi chưa có connector** — kiểm tra `list-connectors` trước.
2. **Idempotency** — HTTP 409 nghĩa là đã tồn tại, dùng `existing_ref`.
3. **Audit trail** — log mọi thao tác vào `timeline.jsonl`.
4. **SSRF** — từ chối private IP trong `base_url`.

---

## 9. Scripts tiện ích

| Script | Mục đích |
|---|---|
| `jira_assign_me_and_done.py` | Bulk assign + transition sang Done theo JQL |
| `publish_roadmap_to_jira_confluence.py` | Publish roadmap → Jira + Confluence |
| `sync_module_confluence_jira_links.py` | Đồng bộ remote link Jira ↔ Confluence |

---

## 10. Xử lý lỗi thường gặp

| Lỗi | Nguyên nhân | Cách xử lý |
|---|---|---|
| `JiraAuthError (401)` | Token sai/hết hạn | Cấp lại PAT |
| `JiraNetworkError: Timeout` | Server chậm | Tăng `READ_TIMEOUT` |
| `HTTP 422: quality gate failed` | Score thấp | Xem `issues` trong response |
| `HTTP 409: đã tồn tại` | Idempotency | Dùng `existing_ref` |
| `JiraRateLimitError (429)` | Quá nhiều request | Retry tự động (exponential backoff) |
