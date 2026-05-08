# Confluence Integration — Rulebook

Quy tắc và hướng dẫn để AI agent làm việc đúng cách với Confluence.
Source connector: `app/connectors/confluence.py` trong `ict-ai-context-engine`.

---

## 1. Cấu hình

### Biến môi trường bắt buộc

```env
AI_CONTEXT_V2_CONFLUENCE_BASE_URL=https://confluence.company.com
AI_CONTEXT_V2_CONFLUENCE_TOKEN=<personal-access-token>
AI_CONTEXT_V2_CONFLUENCE_USERNAME=<email>   # cần cho Confluence Cloud / Basic Auth
AI_CONTEXT_V2_CONFLUENCE_PUBLISH_SPACE=DEV  # space key mặc định khi publish
```

### Auth hỗ trợ

| Loại | Cách dùng |
|---|---|
| **Bearer Token** (Server/DC) | `Authorization: Bearer <token>` |
| **Basic Auth** (Cloud) | `Authorization: Basic base64(username:token)` |

Connector tự thử cả hai phong cách — không cần cấu hình thủ công.

---

## 2. Đăng ký connector

```bash
# Từ .env (khi bootstrap)
python -m app.cli bootstrap

# Thủ công
python -m app.cli setup-confluence \
  --base-url https://confluence.company.com \
  --token <PAT> \
  --username <email>
```

---

## 3. Discover sources (đọc)

### Discover toàn bộ spaces

```bash
python -m app.cli discover-all
```

### Discover từng batch (tránh timeout với Confluence lớn)

```bash
# Batch 1: skip 0 space, lấy tối đa 10 spaces, tối đa 500 pages/space
python -m app.cli discover-all \
  --cf-space-offset 0 \
  --cf-max-spaces 10 \
  --cf-max-pages-per-space 500

# Batch 2: tiếp tục từ space 10
python -m app.cli discover-all --cf-space-offset 10 --cf-max-spaces 10
```

### Ước tính trước khi sync

```bash
python -m app.cli discover-all --cf-estimate-only
```

### Sync tất cả Confluence sources

```bash
python -m app.cli sync-confluence-all --collection knowledge
```

### Thêm trang cụ thể

```bash
python -m app.cli add-confluence "https://confluence.company.com/pages/viewpage.action?pageId=123456"
python -m app.cli sync-source "confluence:123456"
```

---

## 4. Tạo / Cập nhật page (ghi)

### Quy tắc bắt buộc trước khi ghi

1. Agent **phải** có `space_key` hợp lệ — không tự đoán.
2. Nội dung Markdown phải được convert sang **Confluence Storage Format** trước khi gửi.
3. Mọi lần ghi phải log vào `timeline.jsonl` của task dossier.
4. Nếu page đã tồn tại (theo `existing_page_id`), phải **update** — không tạo duplicate.

### Tạo page mới từ Markdown

```python
from app.connectors.confluence import ConfluenceConnector, markdown_to_storage
from app.core.config import settings

cf = ConfluenceConnector(
    settings.confluence_base_url,
    settings.confluence_token,
    settings.confluence_username,
)
storage = markdown_to_storage("# Tiêu đề\n\nNội dung...")
cf.create_page(space_key="DEV", title="Tên trang", body_storage=storage)
```

### Cập nhật page hiện có

```python
# Phải lấy version_number hiện tại trước
page = cf.get_page(page_id="123456")
current_version = page["version"]["number"]

cf.update_page(
    page_id="123456",
    title="Tên trang",
    body_storage=storage,
    version_number=current_version + 1,
)
```

### Tìm kiếm bằng CQL

```python
results = cf.search_pages(cql='space = "DEV" AND title ~ "Payment"', limit=10)
```

---

## 5. Publish tài liệu được AI sinh ra

Khi agent sinh requirements/design doc → có thể publish lên Confluence:

```bash
# Sinh requirements + publish
python -m app.cli rde-requirements \
  "Xây dựng tính năng thanh toán VNPay" \
  --publish \
  --space DEV

# Sinh design doc + publish
python -m app.cli rde-design requirements.md \
  --publish \
  --space DEV
```

---

## 6. Sync Confluence ↔ Jira (liên kết)

Sau khi tạo page Confluence, gắn remote link vào Jira ticket tương ứng:

```python
jira.add_remote_link(
    issue_key="PROJ-123",
    url="https://confluence.company.com/...",
    title="Specs: Module 1 — Payment",
)
```

Xem script mẫu đầy đủ:
`C:\FPT\SourceCode\ict-ai-context-engine\scripts\publish_roadmap_to_jira_confluence.py`

---

## 7. Giới hạn & Anti-patterns

| ❌ Không làm | ✅ Thay bằng |
|---|---|
| Ghi trực tiếp HTML vào Confluence | Dùng `markdown_to_storage()` |
| Tạo duplicate page | Luôn dùng `existing_page_id` nếu đã có |
| Commit `.env` vào git | Dùng `.env.example` template |
| Discover toàn bộ Confluence một lúc (>10k pages) | Dùng batch với `--cf-space-offset` |
| Xoá page từ agent | Chỉ human mới được xoá |

---

## 8. Xử lý lỗi thường gặp

| Lỗi | Nguyên nhân | Cách xử lý |
|---|---|---|
| `HTTP 401` | Token sai hoặc hết hạn | Cấp lại PAT trên Confluence |
| `HTTP 403` | Không có quyền vào space | Yêu cầu admin thêm quyền |
| `HTTP 404` | pageId không tồn tại | Kiểm tra lại URL trang |
| Timeout | Space quá lớn | Dùng `--cf-max-pages-per-space` |
| Private IP rejected | SSRF protection | Dùng hostname, không dùng IP nội bộ |
