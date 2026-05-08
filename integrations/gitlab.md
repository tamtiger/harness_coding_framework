# GitLab Integration — Rulebook

Quy tắc và hướng dẫn để AI agent làm việc đúng cách với GitLab.
Source connector: `app/connectors/gitlab.py` trong `ict-ai-context-engine`.

---

## 1. Cấu hình

```env
AI_CONTEXT_V2_GITLAB_BASE_URL=https://gitlab.company.com
AI_CONTEXT_V2_GITLAB_TOKEN=<personal-access-token>
```

### Đăng ký connector

```bash
python -m app.cli setup-gitlab \
  --base-url https://gitlab.company.com \
  --token <PAT>
```

---

## 2. Discover GitLab sources

```bash
python -m app.cli discover-all     # discover cả GitLab + Confluence
python -m app.cli sync-git-all     # sync + ingest tất cả Git repos
```

### Thêm repo cụ thể

```bash
python -m app.cli add-git "https://gitlab.company.com/group/repo"
python -m app.cli sync-source <source_id>
```

---

## 3. Quy tắc làm việc với branch (GitLab)

### Naming convention bắt buộc

```
features/{ten-dev}-{ma-ticket-jira}-{slug-noi-dung}
```

**Ví dụ:**
```
features/datnm11-PAYMENT-123-add-vnpay-callback
features/tamnt167-OMS-456-fix-order-status-sync
```

### Quy trình tạo branch từ agent

```python
from app.connectors.gitlab import GitLabConnector
from app.core.config import settings

gl = GitLabConnector(settings.gitlab_base_url, settings.gitlab_token)

# 1. Lấy project
project = gl.get_project_by_url("https://gitlab.company.com/group/repo")
project_id = project["id"]

# 2. Kiểm tra branch đã tồn tại chưa
existing = gl.get_branch(project_id, "features/dev-PROJ-123-slug")
if not existing:
    # 3. Tạo branch từ main
    gl.create_branch(project_id, "features/dev-PROJ-123-slug", ref="main")
```

---

## 4. Commit files

```python
gl.commit_files(
    project_id=project_id,
    branch_name="features/dev-PROJ-123-slug",
    files=[
        {
            "file_path": "src/Payment/Handlers/VNPayHandler.cs",
            "content": "...",
            "action": "create",   # hoặc "update", "delete"
        }
    ],
    commit_message="feat(payment): add VNPay callback handler [PROJ-123]",
)
```

### Conventional commit format

```
<type>(<scope>): <description> [<JIRA-KEY>]

type: feat | fix | docs | refactor | test | chore
scope: tên module (payment, orders, auth, ...)
```

---

## 5. Tạo Merge Request

```python
mr = gl.create_merge_request(
    project_id=project_id,
    source_branch="features/dev-PROJ-123-slug",
    target_branch="main",
    title="feat(payment): Add VNPay callback handler",
    description="## Mô tả\n\n...\n\n## Jira\n\n[PROJ-123](https://jira.company.com/browse/PROJ-123)",
)
print(mr["web_url"])  # URL của MR
```

---

## 6. Quy tắc bắt buộc

1. **Không tạo branch trực tiếp trên `main`** — luôn tạo feature branch.
2. **Luôn sync repo mới nhất trước khi implement** — `sync-source <id>`.
3. **Branch phải thuộc repo source đang sửa** — không tạo branch nhầm repo.
4. **Không commit code chưa qua build/test**.
5. **MR luôn cần human review** — không tự merge.
6. **PROD deploy luôn cần human approve** — không tự deploy lên production.

---

## 7. Code Generation Pipeline (CGP)

Pipeline đầy đủ từ design doc → code → branch → MR:

```bash
# 1. Phân tích design doc → danh sách coding tasks
python -m app.cli cgp-decompose design.md

# 2. Sinh code cho từng task
python -m app.cli cgp-generate task.json

# 3. Sinh conventional commit message từ diff
git diff | python -m app.cli cgp-commit-message -

# 4. Chạy toàn bộ pipeline
python -m app.cli cgp-run-pipeline design.md \
  --source-id <git_source_id> \
  --branch features/dev-PROJ-123-slug \
  --from-branch main
```

---

## 8. Xử lý lỗi thường gặp

| Lỗi | Nguyên nhân | Cách xử lý |
|---|---|---|
| `HTTP 401` | Token sai | Kiểm tra `GITLAB_TOKEN` trong `.env` |
| `HTTP 403` | Không có quyền project | Yêu cầu admin thêm Member/Maintainer |
| `HTTP 404` | Branch/project không tồn tại | Kiểm tra lại path_with_namespace |
| Branch đã tồn tại | `create_branch` lỗi | Dùng `get_branch()` kiểm tra trước |
| Merge conflict | Code diverged | Sync latest từ main rồi rebase |
