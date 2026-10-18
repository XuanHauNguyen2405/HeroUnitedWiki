import os
import json
import glob

def scan_all_configs():
    config_dir = "config"
    files = sorted(glob.glob(os.path.join(config_dir, "*.config")))
    
    json_files = {}
    non_json_files = {}
    
    for fpath in files:
        fname = os.path.basename(fpath)
        try:
            with open(fpath, "r", encoding="utf-8") as f:
                data = json.load(f)
                count = len(data) if isinstance(data, (dict, list)) else 1
                sample_keys = []
                if isinstance(data, dict):
                    first_val = next(iter(data.values()))
                    if isinstance(first_val, dict):
                        sample_keys = list(first_val.keys())[:8]
                elif isinstance(data, list) and data:
                    if isinstance(data[0], dict):
                        sample_keys = list(data[0].keys())[:8]
                json_files[fname] = {
                    "type": type(data).__name__,
                    "count": count,
                    "sample_keys": sample_keys
                }
        except Exception as e:
            # check first 32 bytes
            with open(fpath, "rb") as f:
                header = f.read(32)
            non_json_files[fname] = {
                "error": str(e),
                "header_hex": header.hex(),
                "header_str": repr(header)
            }
            
    print(f"Total config files: {len(files)}")
    print(f"Valid JSON config files: {len(json_files)}")
    print(f"Non-JSON config files: {len(non_json_files)}")
    
    if non_json_files:
        print("\n--- Non-JSON files ---")
        for k, v in non_json_files.items():
            print(f"{k}: {v['error'][:60]} | Header: {v['header_str']}")
            
    with open("output/config_scan_summary.json", "w", encoding="utf-8") as f:
        json.dump({"json_files": json_files, "non_json_files": non_json_files}, f, ensure_ascii=False, indent=2)

if __name__ == "__main__":
    scan_all_configs()
