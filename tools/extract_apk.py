import os
import sys
import json
import zipfile
import hashlib
import struct
from collections import defaultdict, Counter

def compute_sha256(filepath):
    h = hashlib.sha256()
    with open(filepath, "rb") as f:
        while chunk := f.read(65536):
            h.update(chunk)
    return h.hexdigest()

def decode_axml_manifest(data):
    """Decode basic metadata from AndroidManifest.xml binary format."""
    strings = []
    pos = 8
    while pos < len(data):
        chunk_type, chunk_size = struct.unpack('<II', data[pos:pos+8])
        if chunk_type == 0x001c0001:
            string_count, style_count, flags, strings_start, styles_start = struct.unpack('<IIIII', data[pos+8:pos+28])
            offsets = [struct.unpack('<I', data[pos+28+i*4:pos+32+i*4])[0] for i in range(string_count)]
            str_data_start = pos + strings_start
            is_utf8 = (flags & (1 << 8)) != 0
            for off in offsets:
                s_pos = str_data_start + off
                if is_utf8:
                    u8len = data[s_pos+1] if data[s_pos] & 0x80 else data[s_pos]
                    s_pos += 2 if data[s_pos] & 0x80 else 1
                    s = data[s_pos:s_pos+u8len].decode('utf-8', errors='ignore')
                else:
                    u16len = struct.unpack('<H', data[s_pos:s_pos+2])[0]
                    s = data[s_pos+2:s_pos+2+u16len*2].decode('utf-16le', errors='ignore')
                strings.append(s)
            break
        pos += chunk_size
        
    attrs = {}
    while pos < len(data):
        chunk_type, chunk_size = struct.unpack('<II', data[pos:pos+8])
        if chunk_type == 0x00100102: # START_TAG
            _, _, ns, name_idx, _, _, attr_count, _, _, _ = struct.unpack('<IIIIHHHHHH', data[pos+8:pos+36])
            tag_name = strings[name_idx]
            attr_offset = pos + 36
            if tag_name == 'manifest':
                for _ in range(attr_count):
                    a_ns, a_name, a_val_str, a_type, a_data = struct.unpack('<IIIII', data[attr_offset:attr_offset+20])
                    attr_name = strings[a_name]
                    val = strings[a_val_str] if a_val_str != 0xffffffff else a_data
                    attrs[attr_name] = val
                    attr_offset += 20
                break
        pos += chunk_size
    return attrs

def run_apk_extraction(apk_path="apk/game.apk", output_dir="output/apk_extracted"):
    print("=== STARTING OFFICIAL APK EXTRACTION & ASSET RESOLUTION PIPELINE ===")
    if not os.path.exists(apk_path):
        raise FileNotFoundError(f"APK file not found: {apk_path}")

    # 1. Inspect APK Information
    print("\n[1/5] Inspecting APK Information & Computing SHA-256...")
    apk_size = os.path.getsize(apk_path)
    apk_sha256 = compute_sha256(apk_path)
    print(f"  APK Path: {apk_path}")
    print(f"  APK Size: {apk_size:,} bytes ({apk_size / (1024*1024):.2f} MB)")
    print(f"  APK SHA-256: {apk_sha256}")

    with zipfile.ZipFile(apk_path, "r") as z:
        manifest_raw = z.read("AndroidManifest.xml")
        manifest_meta = decode_axml_manifest(manifest_raw)
        total_files = len(z.infolist())

    apk_info = {
        "file_name": os.path.basename(apk_path),
        "file_path": apk_path.replace("\\", "/"),
        "size_bytes": apk_size,
        "size_mb": round(apk_size / (1024 * 1024), 2),
        "sha256": apk_sha256,
        "package_name": manifest_meta.get("package", "com.kaiqigu.cjyxyn.kvsdk"),
        "version_name": str(manifest_meta.get("versionName", "1.9")),
        "version_code": int(manifest_meta.get("versionCode", 10)),
        "compile_sdk": manifest_meta.get("compileSdkVersion", 28),
        "target_sdk": manifest_meta.get("targetSdkVersion", 28),
        "min_sdk": manifest_meta.get("minSdkVersion", 19),
        "total_files_in_apk": total_files
    }
    print(f"  Package Name: {apk_info['package_name']}")
    print(f"  Version: {apk_info['version_name']} (Code: {apk_info['version_code']})")
    print(f"  Total Files in Archive: {apk_info['total_files_in_apk']:,}")

    # 2. Extract APK to output/apk_extracted/
    print(f"\n[2/5] Extracting APK archive to {output_dir}...")
    os.makedirs(output_dir, exist_ok=True)
    with zipfile.ZipFile(apk_path, "r") as z:
        z.extractall(output_dir)
    print(f"  Extracted {total_files:,} files into {output_dir}")

    # Save apk_info.json
    info_path = os.path.join(output_dir, "apk_info.json")
    with open(info_path, "w", encoding="utf-8") as f:
        json.dump(apk_info, f, ensure_ascii=False, indent=2)
    print(f"  Saved package info: {info_path}")

    # 3. Index All Assets from Resources/ and output/apk_extracted/
    print("\n[3/5] Building Combined Asset Index (Resources/ + APK)...")
    res_index = defaultdict(list)
    
    # Scan Resources/
    if os.path.exists("Resources"):
        for root, _, files in os.walk("Resources"):
            for f in files:
                rel = os.path.relpath(os.path.join(root, f), ".").replace("\\", "/")
                low = f.lower()
                base = os.path.splitext(low)[0]
                res_index[low].append({"path": rel, "source": "resources"})
                res_index[base].append({"path": rel, "source": "resources"})

    # Scan output/apk_extracted/
    apk_res_count = 0
    for root, _, files in os.walk(output_dir):
        for f in files:
            rel = os.path.relpath(os.path.join(root, f), ".").replace("\\", "/")
            low = f.lower()
            base = os.path.splitext(low)[0]
            res_index[low].append({"path": rel, "source": "apk"})
            res_index[base].append({"path": rel, "source": "apk"})
            apk_res_count += 1

    # Deduplicate candidates
    for k in res_index:
        seen = set()
        unique = []
        for item in res_index[k]:
            if item["path"] not in seen:
                seen.add(item["path"])
                unique.append(item)
        res_index[k] = unique

    print(f"  Total Indexed Tokens: {len(res_index):,} tokens across Resources and APK Extracted ({apk_res_count:,} files from APK)")

    # 4. Resolve Image References from Datasets
    print("\n[4/5] Matching Image References from JSON Datasets...")
    
    def resolve_token(ref):
        if not ref:
            return {"ref": None, "status": "empty", "candidates": [], "path": None, "source": None}
        clean = str(ref).strip()
        low = clean.lower()
        low_png = low if (low.endswith(".png") or low.endswith(".jpg")) else low + ".png"
        
        candidates = res_index.get(low, [])
        if not candidates and low_png in res_index:
            candidates = res_index.get(low_png, [])
            
        if len(candidates) == 0:
            return {"ref": clean, "status": "not_found", "candidates": [], "path": None, "source": None}
        elif len(candidates) == 1:
            return {
                "ref": clean,
                "status": "found",
                "candidates": [c["path"] for c in candidates],
                "path": candidates[0]["path"],
                "source": candidates[0]["source"]
            }
        else:
            paths = [c["path"] for c in candidates]
            # Check if all candidates are exact duplicates across Resources and APK
            # e.g., Resources/iphonehd/icon/x.png vs output/apk_extracted/assets/iphonehd/icon/x.png
            return {
                "ref": clean,
                "status": "ambiguous",
                "candidates": paths,
                "path": None,
                "source": "both" if any(c["source"] == "resources" for c in candidates) and any(c["source"] == "apk" for c in candidates) else candidates[0]["source"]
            }

    # Load Extracted Datasets
    with open("output/heroes.json", "r", encoding="utf-8") as f:
        heroes = json.load(f)
    with open("output/skills.json", "r", encoding="utf-8") as f:
        skills = json.load(f)
    with open("output/equipment.json", "r", encoding="utf-8") as f:
        equips = json.load(f)
    with open("output/items.json", "r", encoding="utf-8") as f:
        items = json.load(f)

    # Resolve references
    manifest = {
        "apk_info": apk_info,
        "summary": {},
        "heroes": {},
        "skills": {},
        "equipment": {},
        "items": {}
    }

    # Heroes
    hero_stats = Counter()
    for hid, h in heroes.items():
        img_ref = h.get("assets", {}).get("image", {}).get("ref")
        anim_ref = h.get("assets", {}).get("animation", {}).get("ref")
        img_res = resolve_token(img_ref)
        anim_res = resolve_token(anim_ref)
        hero_stats[f"image_{img_res['status']}"] += 1
        hero_stats[f"anim_{anim_res['status']}"] += 1
        manifest["heroes"][hid] = {
            "name": h.get("name"),
            "image": img_res,
            "animation": anim_res
        }

    # Skills
    skill_stats = Counter()
    for sid, s in skills.items():
        icon_ref = s.get("assets", {}).get("icon", {}).get("ref")
        sprite_ref = s.get("assets", {}).get("sprite_py", {}).get("ref")
        icon_res = resolve_token(icon_ref)
        sprite_res = resolve_token(sprite_ref)
        skill_stats[f"icon_{icon_res['status']}"] += 1
        skill_stats[f"sprite_{sprite_res['status']}"] += 1
        manifest["skills"][sid] = {
            "name": s.get("name"),
            "icon": icon_res,
            "sprite_py": sprite_res
        }

    # Equipment
    equip_stats = Counter()
    for eid, e in equips.items():
        img_ref = e.get("assets", {}).get("image", {}).get("ref")
        sprite_ref = e.get("assets", {}).get("sprite_py", {}).get("ref")
        img_res = resolve_token(img_ref)
        sprite_res = resolve_token(sprite_ref)
        equip_stats[f"image_{img_res['status']}"] += 1
        equip_stats[f"sprite_{sprite_res['status']}"] += 1
        manifest["equipment"][eid] = {
            "name": e.get("name"),
            "slot": e.get("slot"),
            "slot_name": e.get("slot_name"),
            "image": img_res,
            "sprite_py": sprite_res
        }

    # Items
    item_stats = Counter()
    for iid, it in items.items():
        icon_ref = it.get("assets", {}).get("icon", {}).get("ref")
        icon_res = resolve_token(icon_ref)
        item_stats[f"icon_{icon_res['status']}"] += 1
        manifest["items"][iid] = {
            "name": it.get("name"),
            "icon": icon_res
        }

    manifest["summary"] = {
        "heroes": dict(hero_stats),
        "skills": dict(skill_stats),
        "equipment": dict(equip_stats),
        "items": dict(item_stats)
    }

    print("\n--- Summary of Image References Resolution ---")
    print(f"  Heroes Images:      Found: {hero_stats['image_found']}, Ambiguous: {hero_stats['image_ambiguous']}, Not Found: {hero_stats['image_not_found']}")
    print(f"  Heroes Animations:  Found: {hero_stats['anim_found']}, Ambiguous: {hero_stats['anim_ambiguous']}, Not Found: {hero_stats['anim_not_found']}")
    print(f"  Skills Icons:       Found: {skill_stats['icon_found']}, Ambiguous: {skill_stats['icon_ambiguous']}, Not Found: {skill_stats['icon_not_found']}")
    print(f"  Equipment Images:   Found: {equip_stats['image_found']}, Ambiguous: {equip_stats['image_ambiguous']}, Not Found: {equip_stats['image_not_found']}")
    print(f"  Item Icons:         Found: {item_stats['icon_found']}, Ambiguous: {item_stats['icon_ambiguous']}, Not Found: {item_stats['icon_not_found']}")

    # 5. Save output/asset_manifest.json
    print("\n[5/5] Saving Asset Manifest...")
    manifest_path = "output/asset_manifest.json"
    with open(manifest_path, "w", encoding="utf-8") as f:
        json.dump(manifest, f, ensure_ascii=False, indent=2)
    print(f"  Saved: {manifest_path} ({os.path.getsize(manifest_path):,} bytes)")

    return manifest

if __name__ == "__main__":
    run_apk_extraction()
