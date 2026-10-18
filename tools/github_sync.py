# tools/github_sync.py
import urllib.request
import urllib.error
import json
import subprocess
import sys
import os

USER_AGENT = "SAHHT-Wiki-Agent"

def get_git_credentials():
    p = subprocess.Popen(
        ["git", "credential", "fill"],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True
    )
    stdout, _ = p.communicate(input="protocol=https\nhost=github.com\n\n")
    creds = {}
    for line in stdout.splitlines():
        if "=" in line:
            k, v = line.split("=", 1)
            creds[k.strip()] = v.strip()
    return creds

def get_headers():
    token = os.environ.get("GITHUB_TOKEN") or os.environ.get("GH_TOKEN")
    if not token:
        creds = get_git_credentials()
        token = creds.get("password")
    
    if not token:
        raise RuntimeError("Could not find GitHub token from Git Credential Manager or environment.")
        
    return {
        "Authorization": f"Bearer {token}",
        "User-Agent": USER_AGENT,
        "Accept": "application/vnd.github+json"
    }

def check_user_repos():
    req = urllib.request.Request("https://api.github.com/user/repos?per_page=15", headers=get_headers())
    with urllib.request.urlopen(req) as resp:
        repos = json.loads(resp.read().decode())
        print(f"Found {len(repos)} repos for user:")
        for r in repos:
            print(f"  - {r.get('name')} | Private: {r.get('private')} | URL: {r.get('html_url')}")

def create_repo(name="HeroUnitedWiki", private=False):
    payload = {
        "name": name,
        "description": "Siêu Anh Hùng Hội Tụ WIKI - Kho dữ liệu và website tra cứu Tướng, Kỹ Năng, Trang Bị, Bản Sức & Chuyển Sinh",
        "private": private,
        "auto_init": False
    }
    data = json.dumps(payload).encode("utf-8")
    req = urllib.request.Request("https://api.github.com/user/repos", data=data, headers=get_headers(), method="POST")
    try:
        with urllib.request.urlopen(req) as resp:
            repo_info = json.loads(resp.read().decode())
            print("Successfully created repo:", repo_info.get("html_url"))
            print("Clone URL:", repo_info.get("clone_url"))
            return repo_info
    except urllib.error.HTTPError as e:
        err_msg = e.read().decode()
        if e.code == 422 and "already exists" in err_msg:
            print(f"Repo '{name}' already exists.")
            return {"name": name, "exists": True}
        print(f"HTTP Error {e.code}: {err_msg}")
        return None

if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "create":
        is_private = "--private" in sys.argv
        create_repo("HeroUnitedWiki", private=is_private)
    else:
        check_user_repos()
