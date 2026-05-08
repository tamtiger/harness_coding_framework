# Integrations — Confluence, Jira, GitLab

Thư mục này mô tả cách AI agent tích hợp với ba nền tảng cốt lõi trong SDLC:
**Confluence** (tài liệu), **Jira** (quản lý công việc), **GitLab** (source code).

Đây là **lớp rulebook**, không phải code triển khai. Code connector Python thực tế
nằm trong `C:\FPT\SourceCode\ict-ai-context-engine\app\connectors\`.

---

## Mục lục

| File | Nội dung |
|---|---|
| [confluence.md](confluence.md) | Quy tắc đọc/ghi Confluence — discover spaces, sync pages, tạo/cập nhật page |
| [jira.md](jira.md) | Quy tắc làm việc với Jira — sync issues, tạo Epic/Story/Sub-task, brief từ ticket |
| [gitlab.md](gitlab.md) | Quy tắc làm việc với GitLab — list projects, tạo branch, commit, MR |
| [workflows.md](workflows.md) | Luồng tích hợp liên nền tảng: Jira ↔ Confluence ↔ GitLab ↔ Harness |

---

## Nguyên tắc chung

1. **Không đoán URL/token** — mọi credentials đến từ `.env` hoặc catalog connector đã đăng ký.
2. **Idempotency** — mọi thao tác tạo/cập nhật phải an toàn khi chạy nhiều lần.
3. **Quality Gate** — AI không tạo Jira ticket hoặc commit code nếu chưa qua quality gate.
4. **Audit trail** — mọi thao tác ghi (tạo ticket, publish Confluence, push code) phải được log vào `timeline.jsonl` của task dossier.
5. **Human-in-the-loop** — merge vào `main`, deploy PROD luôn cần human approve.

---

## Môi trường cần thiết (`.env`)

```env
# Jira
AI_CONTEXT_V2_JIRA_BASE_URL=https://jira.company.com
AI_CONTEXT_V2_JIRA_TOKEN=<personal-access-token>
AI_CONTEXT_V2_JIRA_PROJECT_KEYS=PROJ,OMS

# Confluence
AI_CONTEXT_V2_CONFLUENCE_BASE_URL=https://confluence.company.com
AI_CONTEXT_V2_CONFLUENCE_TOKEN=<personal-access-token>
AI_CONTEXT_V2_CONFLUENCE_USERNAME=<email-or-username>     # chỉ cần cho Basic Auth
AI_CONTEXT_V2_CONFLUENCE_PUBLISH_SPACE=DEV                # space mặc định để publish

# GitLab
AI_CONTEXT_V2_GITLAB_BASE_URL=https://gitlab.company.com
AI_CONTEXT_V2_GITLAB_TOKEN=<personal-access-token>
```

> **Lưu ý bảo mật:** Token được mã hoá Fernet trước khi lưu vào catalog.db.
> Không bao giờ commit `.env` vào git.

---

## Brainstorm — Tính năng Mở Rộng (Roadmap)

Xem chi tiết tại [workflows.md](workflows.md#brainstorm--tính-năng-mở-rộng).
