# tools/search_super_evo_materials.py
import os
import json

keywords = ['铸魂', '超进化', 'zhuhun', 'chaojinhua', 'breakthrough', 'đúc hồn', 'duc hon']
print("Searching for soul / super evo in config/ and lua/ ...")

for folder in ['config', 'lua']:
    for root, _, files in os.walk(folder):
        for f in files:
            fp = os.path.join(root, f)
            try:
                with open(fp, 'r', encoding='utf-8', errors='ignore') as infile:
                    text = infile.read()
                    for kw in keywords:
                        if kw in text:
                            print(f"[{kw}] -> {fp}")
                            break
            except Exception as e:
                pass
