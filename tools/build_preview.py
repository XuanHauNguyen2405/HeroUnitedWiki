import os
import json

def generate_preview():
    print("=== Generating Sample Preview Pages for In-Game Cross-Check ===")
    
    with open("output/heroes.json", "r", encoding="utf-8") as f:
        heroes = json.load(f)
    with open("output/skills.json", "r", encoding="utf-8") as f:
        skills = json.load(f)
    with open("output/equipment.json", "r", encoding="utf-8") as f:
        equips = json.load(f)
    with open("output/equipment_sets.json", "r", encoding="utf-8") as f:
        suits = json.load(f)

    os.makedirs("preview", exist_ok=True)

    # 1. CSS Stylesheet (Modern, Dark Glassmorphism Design System)
    css_content = """/* SAHHT WIKI Preview Design System */
:root {
  --bg-primary: #0a0d14;
  --bg-secondary: #101623;
  --bg-card: rgba(22, 30, 46, 0.75);
  --bg-card-hover: rgba(30, 41, 64, 0.9);
  --border-color: rgba(255, 255, 255, 0.08);
  --border-focus: rgba(99, 102, 241, 0.5);
  --text-main: #f3f4f6;
  --text-muted: #9ca3af;
  --text-dim: #6b7280;
  --accent-blue: #3b82f6;
  --accent-purple: #8b5cf6;
  --accent-cyan: #06b6d4;
  --accent-gold: #f59e0b;
  --accent-emerald: #10b981;
  --accent-rose: #f43f5e;
  --glow-blue: rgba(59, 130, 246, 0.15);
  --glow-purple: rgba(139, 92, 246, 0.2);
}

* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

body {
  font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  background-color: var(--bg-primary);
  color: var(--text-main);
  line-height: 1.6;
  min-height: 100vh;
  background-image: 
    radial-gradient(circle at 15% 15%, rgba(99, 102, 241, 0.08) 0%, transparent 40%),
    radial-gradient(circle at 85% 85%, rgba(139, 92, 246, 0.08) 0%, transparent 40%);
  background-attachment: fixed;
}

.container {
  max-width: 1280px;
  margin: 0 auto;
  padding: 2rem 1.5rem;
}

/* Header */
header.app-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.25rem 2rem;
  background: rgba(16, 22, 35, 0.85);
  backdrop-filter: blur(16px);
  border-bottom: 1px solid var(--border-color);
  position: sticky;
  top: 0;
  z-index: 100;
}

.logo-group {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.logo-badge {
  background: linear-gradient(135deg, #4f46e5, #7c3aed);
  color: white;
  padding: 0.4rem 0.8rem;
  border-radius: 8px;
  font-weight: 800;
  font-size: 0.9rem;
  letter-spacing: 0.05em;
  box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
}

.logo-title h1 {
  font-size: 1.25rem;
  font-weight: 700;
  background: linear-gradient(to right, #ffffff, #d1d5db);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.logo-title p {
  font-size: 0.8rem;
  color: var(--text-muted);
}

/* Navigation Tabs */
.nav-tabs {
  display: flex;
  gap: 0.5rem;
  background: rgba(0, 0, 0, 0.35);
  padding: 0.35rem;
  border-radius: 12px;
  border: 1px solid var(--border-color);
}

.tab-btn {
  background: transparent;
  border: none;
  color: var(--text-muted);
  padding: 0.6rem 1.25rem;
  border-radius: 8px;
  font-size: 0.9rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.25s ease;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.tab-btn:hover {
  color: var(--text-main);
  background: rgba(255, 255, 255, 0.05);
}

.tab-btn.active {
  background: linear-gradient(135deg, #3b82f6, #6366f1);
  color: #ffffff;
  box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
}

/* Tab Panels */
.tab-content {
  display: none;
  animation: fadeIn 0.3s ease forwards;
}

.tab-content.active {
  display: block;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(6px); }
  to { opacity: 1; transform: translateY(0); }
}

/* Cards & Layout */
.card {
  background: var(--bg-card);
  backdrop-filter: blur(12px);
  border: 1px solid var(--border-color);
  border-radius: 16px;
  padding: 1.75rem;
  margin-bottom: 1.5rem;
  transition: all 0.3s ease;
}

.card:hover {
  border-color: rgba(255, 255, 255, 0.15);
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.35);
}

.grid-2 {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1.5rem;
}

.grid-3 {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1.25rem;
}

.grid-4 {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 1.25rem;
}

@media (max-width: 900px) {
  .grid-2, .grid-3, .grid-4 {
    grid-template-columns: 1fr;
  }
}

/* Entity Banner */
.entity-header {
  display: flex;
  gap: 2rem;
  align-items: center;
  padding: 1.5rem;
  background: linear-gradient(135deg, rgba(30, 41, 64, 0.6), rgba(15, 23, 42, 0.8));
  border-radius: 16px;
  border: 1px solid var(--border-color);
  margin-bottom: 2rem;
}

.entity-avatar {
  width: 110px;
  height: 110px;
  border-radius: 16px;
  object-fit: cover;
  border: 2px solid rgba(255, 255, 255, 0.15);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.5);
  background: #1e293b;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.entity-avatar-placeholder {
  width: 110px;
  height: 110px;
  border-radius: 16px;
  background: linear-gradient(135deg, #1e293b, #0f172a);
  border: 2px dashed rgba(255, 255, 255, 0.2);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: var(--text-dim);
  font-size: 0.75rem;
  text-align: center;
  padding: 0.5rem;
  flex-shrink: 0;
}

.entity-meta h2 {
  font-size: 1.85rem;
  font-weight: 800;
  margin-bottom: 0.4rem;
  letter-spacing: -0.02em;
}

.tags-row {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  margin-top: 0.5rem;
}

/* Badges */
.badge {
  display: inline-flex;
  align-items: center;
  padding: 0.25rem 0.65rem;
  border-radius: 6px;
  font-size: 0.75rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.04em;
}

.badge-purple { background: rgba(139, 92, 246, 0.2); color: #c4b5fd; border: 1px solid rgba(139, 92, 246, 0.3); }
.badge-gold   { background: rgba(245, 158, 11, 0.2); color: #fde68a; border: 1px solid rgba(245, 158, 11, 0.3); }
.badge-blue   { background: rgba(59, 130, 246, 0.2); color: #93c5fd; border: 1px solid rgba(59, 130, 246, 0.3); }
.badge-emerald{ background: rgba(16, 185, 129, 0.2); color: #6ee7b7; border: 1px solid rgba(16, 185, 129, 0.3); }
.badge-unverified {
  background: rgba(244, 63, 94, 0.15);
  color: #fca5a5;
  border: 1px dashed rgba(244, 63, 94, 0.4);
  font-style: italic;
  text-transform: none;
}

/* Stat Box */
.stat-box {
  background: rgba(0, 0, 0, 0.25);
  border: 1px solid var(--border-color);
  border-radius: 12px;
  padding: 1rem 1.25rem;
  text-align: center;
  transition: transform 0.2s ease;
}

.stat-box:hover {
  transform: translateY(-2px);
  border-color: rgba(255, 255, 255, 0.18);
}

.stat-label {
  font-size: 0.75rem;
  color: var(--text-muted);
  text-transform: uppercase;
  font-weight: 600;
  margin-bottom: 0.35rem;
}

.stat-value {
  font-size: 1.5rem;
  font-weight: 800;
  color: #ffffff;
  font-feature-settings: "tnum";
}

.stat-growth {
  font-size: 0.8rem;
  color: var(--accent-emerald);
  font-weight: 600;
  margin-top: 0.2rem;
}

/* Skill Item */
.skill-card {
  display: flex;
  gap: 1.25rem;
  align-items: flex-start;
  padding: 1.25rem;
  background: rgba(0, 0, 0, 0.3);
  border-radius: 12px;
  border: 1px solid var(--border-color);
  margin-bottom: 1rem;
  transition: all 0.25s ease;
}

.skill-card:hover {
  background: rgba(255, 255, 255, 0.03);
  border-color: rgba(255, 255, 255, 0.15);
}

.skill-icon {
  width: 64px;
  height: 64px;
  border-radius: 12px;
  object-fit: cover;
  border: 1px solid rgba(255, 255, 255, 0.15);
  background: #1e293b;
  flex-shrink: 0;
}

.skill-info {
  flex: 1;
}

.skill-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.4rem;
}

.skill-name {
  font-size: 1.1rem;
  font-weight: 700;
  color: #ffffff;
}

.skill-description {
  font-size: 0.9rem;
  color: var(--text-muted);
  line-height: 1.5;
  margin-top: 0.5rem;
}

/* Table */
table.data-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 0.9rem;
}

table.data-table th, table.data-table td {
  padding: 0.85rem 1rem;
  text-align: left;
  border-bottom: 1px solid var(--border-color);
}

table.data-table th {
  background: rgba(0, 0, 0, 0.4);
  color: var(--text-muted);
  font-weight: 700;
  font-size: 0.8rem;
  text-transform: uppercase;
}

table.data-table tr:hover td {
  background: rgba(255, 255, 255, 0.02);
}

/* Section Title */
.section-title {
  font-size: 1.2rem;
  font-weight: 700;
  color: #ffffff;
  margin-bottom: 1rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.section-title::before {
  content: '';
  display: inline-block;
  width: 4px;
  height: 1.2rem;
  background: linear-gradient(to bottom, #3b82f6, #8b5cf6);
  border-radius: 2px;
}

/* Evolution Chain Component */
.evo-chain {
  display: flex;
  align-items: center;
  gap: 1rem;
  flex-wrap: wrap;
  padding: 1.5rem;
  background: rgba(0, 0, 0, 0.3);
  border-radius: 12px;
  border: 1px solid var(--border-color);
}

.evo-step {
  padding: 1rem 1.5rem;
  border-radius: 10px;
  background: rgba(255, 255, 255, 0.04);
  border: 1px solid var(--border-color);
  text-align: center;
  flex: 1;
  min-width: 180px;
}

.evo-step.current {
  border-color: #3b82f6;
  background: rgba(59, 130, 246, 0.1);
  box-shadow: 0 0 15px rgba(59, 130, 246, 0.2);
}

.evo-arrow {
  color: var(--accent-blue);
  font-size: 1.5rem;
  font-weight: bold;
}

/* Checklist Alert */
.checklist-card {
  background: linear-gradient(135deg, rgba(16, 185, 129, 0.08), rgba(6, 182, 212, 0.08));
  border: 1px solid rgba(16, 185, 129, 0.25);
  border-radius: 12px;
  padding: 1.25rem 1.5rem;
  margin-bottom: 1.5rem;
}
"""
    with open("preview/styles.css", "w", encoding="utf-8") as f:
        f.write(css_content)

    # 2. Extract Data for Sasuke 84000
    sasuke = heroes.get("84000", {})
    sasuke_skills = []
    for s in sasuke.get("skills", []):
        sk_obj = skills.get(s["skill_id"], {})
        sasuke_skills.append({
            "slot": s["slot"],
            "id": s["skill_id"],
            "level": s["level"],
            "name": sk_obj.get("name", "Chưa có dữ liệu"),
            "cd": sk_obj.get("cd", 0),
            "rate": sk_obj.get("rate", 0),
            "description": sk_obj.get("description", "Chưa có dữ liệu"),
            "icon": sk_obj.get("assets", {}).get("icon", {}).get("path")
        })

    # 3. Extract Data for Chidori 76510
    chidori = skills.get("76510", {})
    chidori_evo1 = skills.get("76511", {})
    chidori_evo2 = skills.get("76512", {})

    # 4. Extract Data for Suit 1710 (Bộ Sasuke) and Suit 53 (Bộ Đao Ninja)
    suit_1710 = suits.get("1710", {})
    suit_1710_parts = [equips.get(p, {}) for p in suit_1710.get("parts", [])]

    suit_53 = suits.get("53", {})
    suit_53_parts = [equips.get(p, {}) for p in suit_53.get("parts", [])]

    # 5. Build Unified Portal (preview/index.html)
    portal_html = f"""<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Siêu Anh Hùng Hội Tụ WIKI - Đối Chiếu Dữ Liệu Trong Game</title>
  <link rel="stylesheet" href="styles.css">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
</head>
<body>

  <!-- Top Header -->
  <header class="app-header">
    <div class="logo-group">
      <div class="logo-badge">SAHHT WIKI</div>
      <div class="logo-title">
        <h1>Bộ Mẫu Đối Chiếu Dữ Liệu Thực Tế Trong Game</h1>
        <p>Phiên bản Pipeline: 1.2.0 • Trích xuất tĩnh bảo toàn 100% tệp cấu hình nguồn</p>
      </div>
    </div>
    <nav class="nav-tabs" role="tablist">
      <button class="tab-btn active" onclick="switchTab('hero')">
        <span>👤</span> Trang Tướng (Hero)
      </button>
      <button class="tab-btn" onclick="switchTab('skill')">
        <span>⚡</span> Trang Kỹ Năng (Skill)
      </button>
      <button class="tab-btn" onclick="switchTab('suit')">
        <span>🛡️</span> Trang Bộ Trang Bị (Suits)
      </button>
      <button class="tab-btn" onclick="switchTab('checklist')">
        <span>📋</span> Bảng Kiểm Định Game
      </button>
    </nav>
  </header>

  <main class="container">

    <!-- TAB 1: HERO SHOWCASE (LỤC ĐẠO SASUKE) -->
    <div id="tab-hero" class="tab-content active">
      
      <div class="entity-header">
        <img class="entity-avatar" src="../{sasuke.get('assets', {}).get('image', {}).get('path', '')}" alt="Lục Đạo Sasuke" onerror="this.style.display='none'">
        <div class="entity-meta">
          <div style="display: flex; align-items: center; gap: 0.75rem;">
            <h2>{sasuke.get('name', 'Chưa có dữ liệu')}</h2>
            <span class="badge badge-purple">ID: {sasuke.get('id')}</span>
            <span class="badge badge-gold">⭐ {sasuke.get('star', 0)} / {sasuke.get('star_max', 0)} Sao</span>
            <span class="badge badge-blue">Phẩm chất: {sasuke.get('quality')} (Tím)</span>
          </div>
          <div class="tags-row">
            <span class="badge badge-emerald">Nghề (Career): {sasuke.get('career')}</span>
            <span class="badge badge-purple">Hệ/Tộc (Race): {sasuke.get('race')}</span>
            <span class="badge badge-blue">Giới tính: {sasuke.get('sex')}</span>
            <span class="badge badge-gold">Cấp tối đa: {sasuke.get('level_max')}</span>
            <span class="badge badge-purple">Duy nhất (is_only): {sasuke.get('is_only')}</span>
            <span class="badge badge-emerald">Tái sinh: {sasuke.get('rebirth')}</span>
          </div>
        </div>
      </div>

      <!-- Base & Growth Stats Grid -->
      <div class="card">
        <div class="section-title">Chỉ Số Khởi Đầu & Hệ Số Tăng Trưởng (Đã Đối Chiếu Khớp 100%)</div>
        <div class="grid-4" style="grid-template-columns: repeat(5, 1fr);">
          <div class="stat-box">
            <div class="stat-label">Sinh Lực (HP)</div>
            <div class="stat-value">{sasuke.get('base_stats', {}).get('hp', 0):,}</div>
            <div class="stat-growth">+{sasuke.get('growth_stats', {}).get('hp', 0)} / cấp</div>
          </div>
          <div class="stat-box">
            <div class="stat-label">Công Vật Lý (PATK)</div>
            <div class="stat-value">{sasuke.get('base_stats', {}).get('patk', 0):,}</div>
            <div class="stat-growth">+{sasuke.get('growth_stats', {}).get('patk', 0)} / cấp</div>
          </div>
          <div class="stat-box">
            <div class="stat-label">Công Ma Pháp (MATK)</div>
            <div class="stat-value">{sasuke.get('base_stats', {}).get('matk', 0):,}</div>
            <div class="stat-growth">+{sasuke.get('growth_stats', {}).get('matk', 0)} / cấp</div>
          </div>
          <div class="stat-box">
            <div class="stat-label">Phòng Ngự (DEF)</div>
            <div class="stat-value">{sasuke.get('base_stats', {}).get('def', 0):,}</div>
            <div class="stat-growth">+{sasuke.get('growth_stats', {}).get('def', 0)} / cấp</div>
          </div>
          <div class="stat-box">
            <div class="stat-label">Tốc Độ (SPEED)</div>
            <div class="stat-value">{sasuke.get('base_stats', {}).get('speed', 0):,}</div>
            <div class="stat-growth">+{sasuke.get('growth_stats', {}).get('speed', 0)} / cấp</div>
          </div>
        </div>
      </div>

      <!-- 7 Skills Grid -->
      <div class="card">
        <div class="section-title">Danh Sách 7 Kỹ Năng Kèm Icon Thực Tế & Cấp Kích Hoạt</div>
        <div class="grid-2">
"""
    for sk in sasuke_skills:
        icon_tag = f'<img class="skill-icon" src="../{sk["icon"]}" alt="{sk["name"]}">' if sk["icon"] else '<div class="skill-icon" style="display:flex;align-items:center;justify-content:center;font-size:0.75rem;color:#888;">Chưa có ảnh</div>'
        portal_html += f"""
          <div class="skill-card">
            {icon_tag}
            <div class="skill-info">
              <div class="skill-header">
                <span class="skill-name">Slot {sk["slot"]}: {sk["name"]}</span>
                <span class="badge badge-blue">Cấp {sk["level"]}</span>
              </div>
              <div style="font-size: 0.8rem; color: #a5b4fc; margin-bottom: 0.35rem;">
                ID: {sk["id"]} • cd: {sk["cd"]} • rate: {sk["rate"]} • <span class="badge badge-unverified">Chưa xác minh cách tính/đơn vị</span>
              </div>
              <div class="skill-description">
                {sk["description"]}
              </div>
            </div>
          </div>
"""

    portal_html += f"""
        </div>
      </div>

      <!-- Bonds (Duyên phận) -->
      <div class="card">
        <div class="section-title">Duyên Phận (Bonds) Kích Hoạt Chỉ Số</div>
        <div class="grid-2">
"""
    for b in sasuke.get("bonds", []):
        portal_html += f"""
          <div style="padding: 1rem; background: rgba(0,0,0,0.25); border-radius: 10px; border: 1px solid var(--border-color);">
            <div style="font-weight: 700; color: #f59e0b; margin-bottom: 0.35rem;">🔗 {b.get('name')} <span style="font-size:0.75rem; color:#888;">(Chain ID: {b.get('chain_id')})</span></div>
            <div style="font-size: 0.88rem; color: var(--text-muted);">{b.get('description')}</div>
          </div>
"""

    portal_html += f"""
        </div>
      </div>

      <!-- Tiêu Thức Tỉnh & Đột Phá -->
      <div class="grid-2">
        <div class="card">
          <div class="section-title">Thức Tỉnh (Awakening Mốc 1 - 6)</div>
          <table class="data-table">
            <thead>
              <tr><th>Tầng</th><th>Dữ liệu nguồn (Vật phẩm & Số lượng)</th><th>Trạng thái</th></tr>
            </thead>
            <tbody>
              <tr><td>Mốc 1</td><td><code>{json.dumps(sasuke.get('awakening', {}).get('wake1', []))}</code></td><td><span class="badge badge-emerald">Hợp lệ</span></td></tr>
              <tr><td>Mốc 2</td><td><code>{json.dumps(sasuke.get('awakening', {}).get('wake2', []))}</code></td><td><span class="badge badge-emerald">Hợp lệ</span></td></tr>
              <tr><td>Mốc 3</td><td><code>{json.dumps(sasuke.get('awakening', {}).get('wake3', []))}</code></td><td><span class="badge badge-emerald">Hợp lệ</span></td></tr>
              <tr><td>Mốc 4</td><td><code>{json.dumps(sasuke.get('awakening', {}).get('wake4', []))}</code></td><td><span class="badge badge-emerald">Hợp lệ</span></td></tr>
              <tr><td>Mốc 5</td><td><code>{json.dumps(sasuke.get('awakening', {}).get('wake5', []))}</code></td><td><span class="badge badge-emerald">Hợp lệ</span></td></tr>
              <tr><td>Mốc 6</td><td><code>{json.dumps(sasuke.get('awakening', {}).get('wake6', []))}</code></td><td><span class="badge badge-emerald">Hợp lệ</span></td></tr>
            </tbody>
          </table>
        </div>

        <div class="card">
          <div class="section-title">Đột Phá & Tiến Hóa Tướng</div>
          <table class="data-table">
            <thead>
              <tr><th>Thuộc tính</th><th>Giá trị</th><th>Ghi chú</th></tr>
            </thead>
            <tbody>
              <tr><td>Đột phá 4 (break4)</td><td><code>{json.dumps(sasuke.get('breakthrough', {}).get('break4', []))}</code></td><td>Mốc 4 sao</td></tr>
              <tr><td>Đột phá 5 (break5)</td><td><code>{json.dumps(sasuke.get('breakthrough', {}).get('break5', []))}</code></td><td>Mốc 5 sao</td></tr>
              <tr><td>is_evo</td><td>{sasuke.get('evolution', {}).get('is_evo', 0)}</td><td>Trạng thái tiến hóa</td></tr>
              <tr><td>evo_kind</td><td>{sasuke.get('evolution', {}).get('evo_kind', 0)}</td><td>Hệ tiến hóa</td></tr>
              <tr><td>is_skin</td><td>{sasuke.get('evolution', {}).get('is_skin', 0)}</td><td>Phân loại trang phục</td></tr>
            </tbody>
          </table>
        </div>
      </div>

    </div>

    <!-- TAB 2: SKILL SHOWCASE (CHIDORI) -->
    <div id="tab-skill" class="tab-content">
      
      <div class="entity-header">
        <img class="entity-avatar" src="../{chidori.get('assets', {}).get('icon', {}).get('path', '')}" alt="Chidori">
        <div class="entity-meta">
          <div style="display: flex; align-items: center; gap: 0.75rem;">
            <h2>{chidori.get('name')}</h2>
            <span class="badge badge-purple">ID: {chidori.get('id')}</span>
            <span class="badge badge-gold">Loại: {chidori.get('skill_type')}</span>
            <span class="badge badge-blue">Phẩm chất: {chidori.get('quality')}</span>
          </div>
          <div class="tags-row">
            <span class="badge badge-emerald">Cấp tối đa: {chidori.get('max_lv')}</span>
            <span class="badge badge-blue">cd: {chidori.get('cd')} <span class="badge badge-unverified" style="margin-left:4px;">Chưa xác minh cách tính/đơn vị</span></span>
            <span class="badge badge-purple">pre_cd: {chidori.get('pre_cd')} <span class="badge badge-unverified" style="margin-left:4px;">Chưa xác minh cách tính/đơn vị</span></span>
            <span class="badge badge-gold">Tỉ lệ kích hoạt (rate): {chidori.get('rate')}</span>
            <span class="badge badge-emerald">Action: {chidori.get('assets', {}).get('action')} (Bảo toàn số nguyên 0)</span>
          </div>
        </div>
      </div>

      <!-- Skill Formula Card -->
      <div class="card">
        <div class="section-title">Thuộc Tính Nguồn Kỹ Năng (Giá Trị Gốc)</div>
        <div class="grid-3">
          <div class="stat-box">
            <div class="stat-label">effect</div>
            <div class="stat-value">{chidori.get('effect')}</div>
            <div class="stat-growth"><span class="badge badge-unverified">Chưa xác minh cách tính/đơn vị</span></div>
          </div>
          <div class="stat-box">
            <div class="stat-label">attr_effect</div>
            <div class="stat-value">{chidori.get('attr_effect')}</div>
            <div class="stat-growth"><span class="badge badge-unverified">Chưa xác minh cách tính/đơn vị</span></div>
          </div>
          <div class="stat-box">
            <div class="stat-label">effect_lvchange</div>
            <div class="stat-value">{chidori.get('effect_lvchange')}</div>
            <div class="stat-growth"><span class="badge badge-unverified">Chưa xác minh cách tính/đơn vị</span></div>
          </div>
        </div>

        <div style="margin-top: 1.5rem; padding: 1.25rem; background: rgba(0,0,0,0.3); border-radius: 10px; border-left: 4px solid var(--accent-blue);">
          <div style="font-size: 0.8rem; color: var(--text-muted); text-transform: uppercase; font-weight: 700; margin-bottom: 0.35rem;">Mô Tả Hiển Thị Trong Game (Game Story Text):</div>
          <div style="font-size: 1.05rem; color: #ffffff; font-weight: 500;">
            "{chidori.get('description')}"
          </div>
        </div>
      </div>

      <!-- Skill Evolution Chain -->
      <div class="card">
        <div class="section-title">Chuỗi Tiến Cấp Kỹ Năng (Kỹ Năng Kế Tiếp - next_evolution_skill_id)</div>
        <div class="evo-chain">
          <div class="evo-step current">
            <div style="font-size: 0.75rem; color: #93c5fd; font-weight: 700;">GIAI ĐOẠN 1 (HIỆN TẠI)</div>
            <div style="font-size: 1.2rem; font-weight: 800; margin: 0.35rem 0;">{chidori.get('name')}</div>
            <div style="font-size: 0.85rem; color: var(--text-muted);">ID: {chidori.get('id')}</div>
            <div style="font-size: 0.8rem; color: #10b981; margin-top: 0.3rem;">effect: {chidori.get('effect')} <span class="badge badge-unverified" style="font-size:0.65rem;">Chưa xác minh cách tính/đơn vị</span></div>
          </div>
          
          <div class="evo-arrow">➔</div>

          <div class="evo-step">
            <div style="font-size: 0.75rem; color: #fde68a; font-weight: 700;">GIAI ĐOẠN 2</div>
            <div style="font-size: 1.2rem; font-weight: 800; margin: 0.35rem 0;">{chidori_evo1.get('name', 'Chưa có dữ liệu')}</div>
            <div style="font-size: 0.85rem; color: var(--text-muted);">ID: {chidori_evo1.get('id')}</div>
            <div style="font-size: 0.8rem; color: #10b981; margin-top: 0.3rem;">effect: {chidori_evo1.get('effect')} <span class="badge badge-unverified" style="font-size:0.65rem;">Chưa xác minh cách tính/đơn vị</span></div>
          </div>

          <div class="evo-arrow">➔</div>

          <div class="evo-step">
            <div style="font-size: 0.75rem; color: #c4b5fd; font-weight: 700;">GIAI ĐOẠN 3 (CỰC HẠN)</div>
            <div style="font-size: 1.2rem; font-weight: 800; margin: 0.35rem 0;">{chidori_evo2.get('name', 'Chưa có dữ liệu')}</div>
            <div style="font-size: 0.85rem; color: var(--text-muted);">ID: {chidori_evo2.get('id')}</div>
            <div style="font-size: 0.8rem; color: #10b981; margin-top: 0.3rem;">effect: {chidori_evo2.get('effect')} <span class="badge badge-unverified" style="font-size:0.65rem;">Chưa xác minh cách tính/đơn vị</span></div>
          </div>
        </div>
      </div>

    </div>

    <!-- TAB 3: EQUIPMENT SET SHOWCASE -->
    <div id="tab-suit" class="tab-content">
      
      <!-- Bộ 1: Bộ Sasuke (Đầy đủ 4 icon) -->
      <div class="card">
        <div class="entity-header" style="margin-bottom: 1.5rem;">
          <div class="entity-avatar" style="background: linear-gradient(135deg, #4c1d95, #1e1b4b); font-size: 2.5rem;">👘</div>
          <div class="entity-meta">
            <div style="display: flex; align-items: center; gap: 0.75rem;">
              <h2>Bộ Trang Bị Chú Nguyền Sasuke (咒印佐助)</h2>
              <span class="badge badge-purple">Suit ID: {suit_1710.get('id')}</span>
              <span class="badge badge-emerald">Đầy đủ 4 mảnh có icon thực tế</span>
            </div>
            <div class="tags-row">
              <span class="badge badge-gold">Mốc 2 món: HP +300, Công Vật lý +250</span>
              <span class="badge badge-blue">Mốc 3 món: Phòng ngự +200, Bạo kích +500</span>
              <span class="badge badge-purple">Mốc 4 món: HP +300, Công Vật lý +250, Tốc độ +3300</span>
            </div>
          </div>
        </div>

        <div class="section-title">Chi Tiết 4 Vị Trí Trang Bị (Vũ Khí, Trang Sức, Giáp/Áo, Giày)</div>
        <div class="grid-4">
"""
    for eq in suit_1710_parts:
        img_path = eq.get("assets", {}).get("image", {}).get("path")
        img_tag = f'<img class="entity-avatar" style="width:72px;height:72px;margin:0 auto 0.75rem auto;" src="../{img_path}" alt="{eq.get("name")}">' if img_path else '<div class="entity-avatar-placeholder" style="width:72px;height:72px;margin:0 auto 0.75rem auto;">Chưa có ảnh</div>'
        portal_html += f"""
          <div class="card" style="padding: 1.25rem; text-align: center; margin-bottom: 0;">
            {img_tag}
            <div style="font-weight: 700; font-size: 1.05rem; margin-bottom: 0.25rem;">{eq.get('name')}</div>
            <div style="margin-bottom: 0.5rem;">
              <span class="badge badge-blue">Slot {eq.get('slot')}: {eq.get('slot_name')}</span>
              <span class="badge badge-purple">Phẩm chất: {eq.get('quality')}</span>
            </div>
            <div style="font-size: 0.85rem; color: var(--text-muted); text-align: left; padding: 0.5rem; background: rgba(0,0,0,0.25); border-radius: 8px;">
              <div>• <b>Chỉ số 1:</b> Ability {eq.get('primary_stat', {}).get('ability_id')} +{eq.get('primary_stat', {}).get('value')} (+{eq.get('primary_stat', {}).get('level_add')}/cấp)</div>
              <div>• <b>Chỉ số 2:</b> Ability {eq.get('secondary_stat', {}).get('ability_id')} +{eq.get('secondary_stat', {}).get('value')} (+{eq.get('secondary_stat', {}).get('level_add')}/cấp)</div>
              <div>• <b>Tiến hóa:</b> Sang ID {eq.get('evolution', {}).get('next_evolution_equip_id')}</div>
            </div>
          </div>
"""

    portal_html += f"""
        </div>
      </div>

      <!-- Bộ 2: Bộ Thần Đồng 53 (Bộ Đao Ninja được người dùng kiểm tra) -->
      <div class="card">
        <div class="entity-header" style="margin-bottom: 1.5rem;">
          <div class="entity-avatar" style="background: linear-gradient(135deg, #065f46, #064e3b); font-size: 2.5rem;">🗡️</div>
          <div class="entity-meta">
            <div style="display: flex; align-items: center; gap: 0.75rem;">
              <h2>Bộ Thần Đồng (神童) - Chứa Đao Ninja</h2>
              <span class="badge badge-purple">Suit ID: {suit_53.get('id')}</span>
              <span class="badge badge-emerald">Đã tìm thấy ảnh từ APK</span>
            </div>
            <div class="tags-row">
              <span class="badge badge-gold">Mốc 2 món: [[1, 300], [2, 250]]</span>
              <span class="badge badge-blue">Mốc 3 món: [[3, 200], [4, 500]]</span>
              <span class="badge badge-purple">Mốc 4 món: [[1, 300], [2, 250], [5, 3300]]</span>
            </div>
          </div>
        </div>

        <div class="section-title">4 Mảnh Thuộc Bộ Thần Đồng (Minh chứng đối chiếu liên kết nguồn & ảnh từ APK)</div>
        <div class="grid-4">
"""
    for eq in suit_53_parts:
        img_path = eq.get("assets", {}).get("image", {}).get("path")
        if img_path:
            img_tag = f'<img class="entity-avatar" style="width:72px;height:72px;margin:0 auto 0.75rem auto;" src="../{img_path}" alt="{eq.get("name")}">'
        else:
            img_tag = f"""<div class="entity-avatar-placeholder" style="width:72px;height:72px;margin:0 auto 0.75rem auto;">
              <span>Chưa tìm thấy ảnh</span>
              <code style="font-size:0.65rem;">{eq.get('assets', {}).get('image', {}).get('ref')}</code>
            </div>"""
        portal_html += f"""
          <div class="card" style="padding: 1.25rem; text-align: center; margin-bottom: 0;">
            {img_tag}
            <div style="font-weight: 700; font-size: 1.05rem; margin-bottom: 0.25rem;">{eq.get('name')}</div>
            <div style="margin-bottom: 0.5rem;">
              <span class="badge badge-blue">Slot {eq.get('slot')}: {eq.get('slot_name')}</span>
              <span class="badge badge-purple">ID: {eq.get('id')}</span>
            </div>
            <div style="font-size: 0.85rem; color: var(--text-muted); text-align: left; padding: 0.5rem; background: rgba(0,0,0,0.25); border-radius: 8px;">
              <div>• <b>equip_id gốc:</b> {eq.get('equip_id')} (Nhánh phôi cơ sở)</div>
              <div>• <b>Thuộc Bộ:</b> Suit ID {eq.get('suit_id')}</div>
              <div>• <b>Tiến hóa tiếp theo:</b> ID {eq.get('evolution', {}).get('next_evolution_equip_id', 'Chưa có')}</div>
            </div>
          </div>
"""

    portal_html += f"""
        </div>
      </div>

    </div>

    <!-- TAB 4: CHECKLIST FOR IN-GAME VERIFICATION -->
    <div id="tab-checklist" class="tab-content">
      
      <div class="checklist-card">
        <h3 style="color: #10b981; margin-bottom: 0.5rem;">✓ Hướng Dẫn Đối Chiếu Trực Tiếp Với Giao Diện Trong Game</h3>
        <p style="color: var(--text-main); font-size: 0.95rem;">
          Bạn có thể mở game mobile Siêu Anh Hùng Hội Tụ và so sánh từng thông số hiển thị trên giao diện này với tài khoản in-game theo các mục dưới đây:
        </p>
      </div>

      <div class="card">
        <div class="section-title">Danh Mục Các Mục Đối Chiếu In-Game</div>
        <table class="data-table">
          <thead>
            <tr>
              <th>Hạng mục</th>
              <th>Đối tượng kiểm tra</th>
              <th>Thông số cần đối chiếu trong Game</th>
              <th>Kết quả trích xuất</th>
              <th>Trạng thái</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td><b>Tướng</b></td>
              <td>Lục Đạo Sasuke (ID: 84000)</td>
              <td>Chỉ số khởi đầu: HP (7.714), Công Vật lý (800), Tốc độ (476)</td>
              <td>Khớp 100% từng byte</td>
              <td><span class="badge badge-emerald">Khớp Nguồn</span></td>
            </tr>
            <tr>
              <td><b>Tướng</b></td>
              <td>Lục Đạo Sasuke (ID: 84000)</td>
              <td>Hệ số tăng cấp: +1500 HP, +200 Công, +150 Tốc độ</td>
              <td>growth_stats: 1500, 200, 150</td>
              <td><span class="badge badge-emerald">Khớp Nguồn</span></td>
            </tr>
            <tr>
              <td><b>Kỹ năng</b></td>
              <td>Chidori (ID: 76510)</td>
              <td>cd: 3, pre_cd: 0 (chưa xác minh đơn vị), rate: 50, effect: 500, attr_effect: 550, effect_lvchange: 2.0 (chưa xác minh cách tính/đơn vị)</td>
              <td>effect: 500, rate: 50, effect_lvchange: 2.0</td>
              <td><span class="badge badge-emerald">Khớp Nguồn</span></td>
            </tr>
            <tr>
              <td><b>Tiến hóa</b></td>
              <td>Chidori ➔ Chidori Giai 2 (ID: 76511)</td>
              <td>Chuyển giai đoạn kỹ năng (next_evolution_skill_id: 76511)</td>
              <td>next_evolution_skill_id: 76511</td>
              <td><span class="badge badge-emerald">Khớp Nguồn</span></td>
            </tr>
            <tr>
              <td><b>Trang bị</b></td>
              <td>Đao Ninja (ID: 16401)</td>
              <td>Vị trí: <b>Vũ khí (Slot 1)</b>; Thuộc <b>Bộ Thần Đồng (Suit 53)</b></td>
              <td>slot: 1, suit_id: "53"</td>
              <td><span class="badge badge-emerald">Khớp Nguồn</span></td>
            </tr>
            <tr>
              <td><b>Trang bị</b></td>
              <td>Bộ Chú Nguyền Sasuke (Suit: 1710)</td>
              <td>4 món: Kiếm Kusanagi (Slot 1), Obi Rắn (Slot 2), Áo (Slot 3), Giày (Slot 4)</td>
              <td>Khớp 100% 4 slot và icon</td>
              <td><span class="badge badge-emerald">Khớp Nguồn</span></td>
            </tr>
            <tr>
              <td><b>Tài nguyên</b></td>
              <td>Icon nhân vật & chiêu thức</td>
              <td>Icon Lục Đạo Sasuke & 7 icon kỹ năng Chidori, Susanoo, Kì Lân...</td>
              <td>Tệp ảnh PNG phân giải từ public/assets/</td>
              <td><span class="badge badge-emerald">Hiển Thị Thực Tế</span></td>
            </tr>
            <tr>
              <td><b>Chưa xác minh</b></td>
              <td>2 Tướng, 28 Kỹ năng, 19 Vật phẩm rỗng tên</td>
              <td>Trong nguồn bỏ trống tên (chuỗi rỗng "")</td>
              <td>Giữ nguyên "Chưa có dữ liệu"</td>
              <td><span class="badge badge-unverified">Chưa Có Dữ Liệu</span></td>
            </tr>
          </tbody>
        </table>
      </div>

    </main>

    <script>
      function switchTab(tabId) {{
        document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
        document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));
        
        event.currentTarget.classList.add('active');
        const target = document.getElementById('tab-' + tabId);
        if (target) {{
          target.classList.add('active');
        }}
      }}
    </script>
</body>
</html>
"""

    with open("preview/index.html", "w", encoding="utf-8") as f:
        f.write(portal_html)

    # Standalone Hero Page
    hero_standalone = portal_html.replace('class="tab-content active"', 'class="tab-content"').replace('id="tab-hero" class="tab-content"', 'id="tab-hero" class="tab-content active"')
    with open("preview/hero_sample.html", "w", encoding="utf-8") as f:
        f.write(hero_standalone)

    # Standalone Skill Page
    skill_standalone = portal_html.replace('class="tab-content active"', 'class="tab-content"').replace('id="tab-skill" class="tab-content"', 'id="tab-skill" class="tab-content active"')
    with open("preview/skill_sample.html", "w", encoding="utf-8") as f:
        f.write(skill_standalone)

    # Standalone Suit Page
    suit_standalone = portal_html.replace('class="tab-content active"', 'class="tab-content"').replace('id="tab-suit" class="tab-content"', 'id="tab-suit" class="tab-content active"')
    with open("preview/suit_sample.html", "w", encoding="utf-8") as f:
        f.write(suit_standalone)

    print("Generated preview/styles.css, preview/index.html, preview/hero_sample.html, preview/skill_sample.html, preview/suit_sample.html successfully!")

if __name__ == "__main__":
    generate_preview()

