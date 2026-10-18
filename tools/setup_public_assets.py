#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
tools/setup_public_assets.py
----------------------------
Tạo thư mục assets độc lập (public/assets/) cho SAHHT Wiki:
1. Quét toàn bộ đường dẫn ảnh và tài nguyên được tham chiếu trong output/*.json và output/asset_manifest.json.
2. Sao chép toàn bộ tệp vào public/assets/ giữ cấu trúc thư mục con chuẩn hóa.
3. Cơ chế chống ghi đè: Với các tệp trùng tên nhưng khác nội dung (khác SHA-256), tạo đường dẫn riêng biệt.
4. Cập nhật output/heroes.json, output/skills.json, output/equipment.json, output/items.json,
   và output/asset_manifest.json để trỏ trực tiếp tới public/assets/.
5. Kiểm tra và báo cáo tính toàn vẹn 100%.
"""

import os
import sys
import json
import shutil
import hashlib

def compute_sha256(filepath):
    h = hashlib.sha256()
    with open(filepath, "rb") as f:
        while chunk := f.read(65536):
            h.update(chunk)
    return h.hexdigest()

def normalize_relpath(p):
    p = p.replace("\\", "/").strip("/")
    prefixes = [
        "output/apk_extracted/assets/",
        "output/apk_extracted/",
        "Resources/"
    ]
    for pre in prefixes:
        if p.startswith(pre):
            return p[len(pre):]
    return p

def main():
    print("=== SAHHT WIKI: SETUP INDEPENDENT PUBLIC ASSETS ===")
    
    public_root = "public/assets"
    os.makedirs(public_root, exist_ok=True)
    
    json_files = {
        "heroes": "output/heroes.json",
        "skills": "output/skills.json",
        "equipment": "output/equipment.json",
        "items": "output/items.json"
    }
    manifest_path = "output/asset_manifest.json"
    
    # 1. Collect all referenced paths across datasets
    all_source_paths = set()
    datasets = {}
    for name, fpath in json_files.items():
        if not os.path.exists(fpath):
            print(f"[ERROR] Required dataset not found: {fpath}")
            sys.exit(1)
        with open(fpath, "r", encoding="utf-8") as f:
            data = json.load(f)
            datasets[name] = data
            for item in data.values():
                assets = item.get("assets", {})
                for a_val in assets.values():
                    if isinstance(a_val, dict):
                        p = a_val.get("path")
                        if p:
                            all_source_paths.add(p)
                        for c in a_val.get("candidates", []):
                            all_source_paths.add(c)
                            
    manifest = {}
    if os.path.exists(manifest_path):
        with open(manifest_path, "r", encoding="utf-8") as f:
            manifest = json.load(f)
        for cat in ["heroes", "skills", "equipment", "items"]:
            cat_data = manifest.get(cat, {})
            for item in cat_data.values():
                for a_val in item.values():
                    if isinstance(a_val, dict):
                        p = a_val.get("path")
                        if p:
                            all_source_paths.add(p)
                        for c in a_val.get("candidates", []):
                            all_source_paths.add(c)

    print(f"Total distinct referenced asset paths found: {len(all_source_paths)}")

    # 2. Copy each file to public/assets/ with collision safety
    path_mapping = {}  # old_path -> new_path
    copied_count = 0
    reused_count = 0
    collision_renamed_count = 0
    total_bytes = 0
    
    # Sort for deterministic processing
    sorted_sources = sorted(list(all_source_paths))
    
    dest_path_hashes = {}  # dest_path -> sha256
    
    for src in sorted_sources:
        if not os.path.exists(src):
            print(f"[WARN] Source file missing on disk: {src}")
            continue
            
        src_hash = compute_sha256(src)
        rel = normalize_relpath(src)
        dest = os.path.join(public_root, rel).replace("\\", "/")
        
        # Check collision
        if dest in dest_path_hashes:
            existing_hash = dest_path_hashes[dest]
            if existing_hash == src_hash:
                # Same content: reuse
                path_mapping[src] = dest
                reused_count += 1
                continue
            else:
                # Same path but DIFFERENT content: generate distinct path
                base_dir = os.path.dirname(dest)
                fname = os.path.basename(dest)
                stem, ext = os.path.splitext(fname)
                discrim_dest = f"{base_dir}/{stem}__{src_hash[:8]}{ext}".replace("\\", "/")
                dest = discrim_dest
                collision_renamed_count += 1
                print(f"  [COLLISION HANDLED] Distinct content for {rel} -> {dest}")
        
        # Copy to destination if not already copied with identical hash
        if not os.path.exists(dest) or compute_sha256(dest) != src_hash:
            os.makedirs(os.path.dirname(dest), exist_ok=True)
            shutil.copy2(src, dest)
            copied_count += 1
            total_bytes += os.path.getsize(dest)
        else:
            reused_count += 1
            
        dest_path_hashes[dest] = src_hash
        path_mapping[src] = dest

    print(f"\nAsset Copy Summary:")
    print(f"  - Files copied / verified: {len(path_mapping)}")
    print(f"  - Newly written: {copied_count}")
    print(f"  - Identical reuses: {reused_count}")
    print(f"  - Collisions renamed: {collision_renamed_count}")
    print(f"  - Total copied size: {total_bytes / (1024*1024):.2f} MB")

    # 3. Update datasets
    print("\nUpdating JSON datasets...")
    for name, data in datasets.items():
        updated_records = 0
        for item in data.values():
            assets = item.get("assets", {})
            for a_val in assets.values():
                if isinstance(a_val, dict):
                    old_p = a_val.get("path")
                    if old_p in path_mapping:
                        a_val["path"] = path_mapping[old_p]
                        updated_records += 1
                    old_c = a_val.get("candidates", [])
                    new_c = [path_mapping.get(c, c) for c in old_c]
                    a_val["candidates"] = new_c
        
        save_path = json_files[name]
        with open(save_path, "w", encoding="utf-8") as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        print(f"  [SAVED] {save_path} (updated asset paths)")

    # 4. Update Manifest
    if manifest:
        print("\nUpdating asset manifest...")
        for cat in ["heroes", "skills", "equipment", "items"]:
            cat_data = manifest.get(cat, {})
            for item in cat_data.values():
                for a_val in item.values():
                    if isinstance(a_val, dict):
                        old_p = a_val.get("path")
                        if old_p in path_mapping:
                            a_val["path"] = path_mapping[old_p]
                        old_c = a_val.get("candidates", [])
                        new_c = [path_mapping.get(c, c) for c in old_c]
                        a_val["candidates"] = new_c
                        if "source" in a_val and a_val.get("status") == "found":
                            a_val["source"] = "public_assets"
                            
        manifest["asset_directory"] = "public/assets"
        with open(manifest_path, "w", encoding="utf-8") as f:
            json.dump(manifest, f, ensure_ascii=False, indent=2)
        print(f"  [SAVED] {manifest_path} (updated to public/assets/)")

    # 5. Integrity verification
    print("\nVerifying asset availability in public/assets/...")
    missing_in_public = 0
    for old_src, new_dest in path_mapping.items():
        if not os.path.exists(new_dest):
            print(f"  [MISSING] {new_dest}")
            missing_in_public += 1
            
    if missing_in_public == 0:
        print("  [SUCCESS] 100% of mapped assets exist in public/assets/!")
    else:
        print(f"  [FAIL] {missing_in_public} assets missing!")
        sys.exit(1)

if __name__ == "__main__":
    main()
