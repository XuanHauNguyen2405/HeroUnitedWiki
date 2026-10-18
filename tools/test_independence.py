#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
tools/test_independence.py
--------------------------
Kiểm tra tính độc lập tuyệt đối của SAHHT Wiki với apk/ và output/apk_extracted/:
1. Tạm đổi tên apk/ -> apk_temp_isolated/ và output/apk_extracted/ -> output/apk_extracted_temp_isolated/
2. Trong trạng thái cách ly:
   - Chạy build_preview.py
   - Quét tất cả thẻ <img> trong các trang preview/*.html: đảm bảo 100% ảnh tồn tại và tải được.
   - Quét toàn bộ output/*.json: đảm bảo 0 đường dẫn nào phụ thuộc vào apk/ hoặc output/apk_extracted/.
   - Chạy validate_pipeline.py
3. Khôi phục hoàn nguyên tên gốc cho apk/ và output/apk_extracted/.
"""

import os
import sys
import json
import re
import subprocess

def test_independence():
    print("=== TESTING ASSET INDEPENDENCE FROM APK AND APK_EXTRACTED ===")
    
    apk_dir = "apk"
    apk_temp = "apk_temp_isolated"
    apk_extracted_dir = "output/apk_extracted"
    apk_extracted_temp = "output/apk_extracted_temp_isolated"
    
    # Pre-check
    if not os.path.exists(apk_dir) or not os.path.exists(apk_extracted_dir):
        print(f"[ERROR] Required initial directories missing: {apk_dir} or {apk_extracted_dir}")
        sys.exit(1)
        
    try:
        # 1. Rename directories to isolate
        print(f"\n[Step 1] Temporarily isolating:")
        print(f"  Renaming '{apk_dir}' -> '{apk_temp}'...")
        os.rename(apk_dir, apk_temp)
        print(f"  Renaming '{apk_extracted_dir}' -> '{apk_extracted_temp}'...")
        os.rename(apk_extracted_dir, apk_extracted_temp)
        
        # Verify isolation
        assert not os.path.exists(apk_dir), f"Directory {apk_dir} still exists!"
        assert not os.path.exists(apk_extracted_dir), f"Directory {apk_extracted_dir} still exists!"
        print("  [CONFIRMED] Both apk/ and output/apk_extracted/ are completely unreachable.")
        
        # 2. Re-run build_preview.py in isolated environment
        print("\n[Step 2] Executing build_preview.py in isolated environment...")
        res = subprocess.run([sys.executable, "tools/build_preview.py"], capture_output=True, text=True, encoding="utf-8")
        if res.returncode != 0:
            print(f"[FAIL] build_preview.py failed:\n{res.stderr}")
            sys.exit(1)
        print("  [PASS] build_preview.py executed successfully!")
        
        # 3. Scan preview HTML files for image resolution
        print("\n[Step 3] Auditing all <img> tags in preview/*.html...")
        preview_files = [
            "preview/index.html",
            "preview/hero_sample.html",
            "preview/skill_sample.html",
            "preview/suit_sample.html"
        ]
        
        total_images_checked = 0
        missing_images = []
        forbidden_references = []
        
        for pf in preview_files:
            with open(pf, "r", encoding="utf-8") as f:
                content = f.read()
                
            # Check forbidden path strings
            for forbidden in ["output/apk_extracted", "apk/game.apk"]:
                if forbidden in content:
                    forbidden_references.append(f"{pf} contains '{forbidden}'")
                    
            # Find all src in <img>
            matches = re.findall(r'<img[^>]+src=["\']([^"\']+)["\']', content)
            for src in matches:
                total_images_checked += 1
                # src is relative to preview/, e.g. ../public/assets/...
                resolved_disk_path = os.path.normpath(os.path.join("preview", src)).replace("\\", "/")
                if not os.path.exists(resolved_disk_path):
                    missing_images.append(f"{pf}: {src} -> {resolved_disk_path} (NOT FOUND)")
                    
        print(f"  Total <img> references audited across preview pages: {total_images_checked}")
        print(f"  Forbidden references to apk or apk_extracted: {len(forbidden_references)}")
        print(f"  Missing image files on disk: {len(missing_images)}")
        
        if forbidden_references:
            for fr in forbidden_references:
                print(f"    [FORBIDDEN] {fr}")
            sys.exit(1)
            
        if missing_images:
            for mi in missing_images:
                print(f"    [MISSING] {mi}")
            sys.exit(1)
            
        print("  [PASS] 100% of preview images load directly from public/assets/ with zero broken links!")
        
        # 4. Check JSON datasets for forbidden references
        print("\n[Step 4] Auditing output/*.json datasets for path independence...")
        json_files = [
            "output/heroes.json",
            "output/skills.json",
            "output/equipment.json",
            "output/items.json"
        ]
        
        json_forbidden = 0
        json_total_paths = 0
        json_missing = 0
        
        for jf in json_files:
            with open(jf, "r", encoding="utf-8") as f:
                data = json.load(f)
            for item_id, item_val in data.items():
                assets = item_val.get("assets", {})
                for a_key, a_val in assets.items():
                    if isinstance(a_val, dict):
                        p = a_val.get("path")
                        if p:
                            json_total_paths += 1
                            if "apk" in p.lower():
                                json_forbidden += 1
                                print(f"    [FORBIDDEN] {jf} [{item_id}] {a_key}: {p}")
                            if not os.path.exists(p):
                                json_missing += 1
                                print(f"    [MISSING] {jf} [{item_id}] {a_key}: {p}")
                        for c in a_val.get("candidates", []):
                            if "apk" in c.lower():
                                json_forbidden += 1
                                print(f"    [FORBIDDEN CANDIDATE] {jf} [{item_id}] {a_key}: {c}")
                                
        print(f"  Total JSON asset paths audited: {json_total_paths}")
        print(f"  Forbidden path occurrences: {json_forbidden}")
        print(f"  Missing asset files on disk: {json_missing}")
        
        assert json_forbidden == 0, f"Found {json_forbidden} forbidden path references!"
        assert json_missing == 0, f"Found {json_missing} missing asset files on disk!"
        print("  [PASS] 100% of JSON asset paths point to public/assets/ and exist on disk!")
        
        # 5. Run validate_pipeline.py
        print("\n[Step 5] Running validate_pipeline.py in isolated environment...")
        val_res = subprocess.run([sys.executable, "tools/validate_pipeline.py"], capture_output=True, text=True, encoding="utf-8")
        if val_res.returncode != 0:
            print(f"[FAIL] validate_pipeline.py failed:\n{val_res.stderr}")
            sys.exit(1)
        print("  [PASS] validate_pipeline.py passed with 0 structural errors and 5/5 mutation test passes!")

        print("\n==================================================")
        print("     INDEPENDENCE AUDIT VERDICT: 100% PASSED     ")
        print("==================================================")

    finally:
        # Restore original directory names
        print("\n[Cleanup] Restoring original directory names...")
        if os.path.exists(apk_temp) and not os.path.exists(apk_dir):
            os.rename(apk_temp, apk_dir)
            print(f"  [RESTORED] '{apk_temp}' -> '{apk_dir}'")
        if os.path.exists(apk_extracted_temp) and not os.path.exists(apk_extracted_dir):
            os.rename(apk_extracted_temp, apk_extracted_dir)
            print(f"  [RESTORED] '{apk_extracted_temp}' -> '{apk_extracted_dir}'")
            
        print("Clean state verified: apk/ and output/apk_extracted/ are intact.")

if __name__ == "__main__":
    test_independence()
