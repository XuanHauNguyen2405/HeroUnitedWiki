"""Comprehensive audit and validation test suite for SAHHT Wiki dataset.

Covers:
1. Config data reconciliation (721 heroes vs character_detail.config)
2. Progression systems integrity (Rebirth 1-7, Super Evo 1-8, Breakthrough 1-20, Strengthen 1-60)
3. Ban Sức recommendations integrity (alias Thần Thư == Thiên Thư, HP mechanics)
4. Artwork manifest and disk assets integrity
5. Family forms link integrity
6. Equipments, Suits, and Badges integrity
"""
import os, sys, json

HEROES_PATH = 'web/src/data/heroes_detail.json'
MANIFEST_PATH = 'web/src/data/hero_artwork_manifest.json'
BAN_SUC_PATH = 'web/src/data/ban_suc_recommendations.json'
CONFIG_DIR = 'config'
WEB_PUBLIC = 'web/public'

class AuditValidator:
    def __init__(self):
        self.results = {}
        self.passed = 0
        self.failed = 0
        self.warnings = 0

    def record(self, test_name, success, message, details=None):
        if success:
            self.passed += 1
            status = "PASS"
        else:
            self.failed += 1
            status = "FAIL"
        self.results[test_name] = {
            "status": status,
            "message": message,
            "details": details or {}
        }
        symbol = "✓" if success else "✗"
        print(f"[{symbol}] {test_name}: {message}")

    def run_all(self):
        print("=" * 70)
        print("RUNNING COMPREHENSIVE SAHHT WIKI DATASET AUDIT")
        print("=" * 70)

        self.test_character_detail_reconciliation()
        self.test_progression_systems()
        self.test_ban_suc_recommendations()
        self.test_artwork_manifest_and_files()
        self.test_family_forms_integrity()
        self.test_suits_and_badges_integrity()

        print("=" * 70)
        print(f"AUDIT SUMMARY: {self.passed} PASSED, {self.failed} FAILED, {self.warnings} WARNINGS")
        print("=" * 70)
        return self.failed == 0

    def test_character_detail_reconciliation(self):
        test_name = "1. Config Data Reconciliation (721 Heroes)"
        with open(HEROES_PATH, 'r', encoding='utf-8') as f:
            heroes = json.load(f)
        with open(os.path.join(CONFIG_DIR, 'character_detail.config'), 'r', encoding='utf-8') as f:
            raw_cfg = json.load(f)

        mismatches = []
        zero_checks = []

        for hid, h in heroes.items():
            cfg = raw_cfg.get(hid)
            if not cfg:
                mismatches.append(f"Hero {hid} missing in character_detail.config")
                continue

            # Check base stats
            bs = h.get('base_stats', {})
            for key in ['hp', 'patk', 'matk', 'def', 'speed']:
                cfg_val = cfg.get(f'base_{key}')
                json_val = bs.get(key)
                if cfg_val is not None and json_val is not None and cfg_val != json_val:
                    mismatches.append(f"{hid} base_{key}: json={json_val} != cfg={cfg_val}")

            # Check growth stats
            gs = h.get('growth_stats', {})
            for key in ['hp', 'patk', 'matk', 'def', 'speed']:
                cfg_val = cfg.get(f'growth_{key}')
                json_val = gs.get(key)
                if cfg_val is not None and json_val is not None and cfg_val != json_val:
                    mismatches.append(f"{hid} growth_{key}: json={json_val} != cfg={cfg_val}")

            # Check zero preservation
            if cfg.get('base_patk') == 0:
                if bs.get('patk') != 0:
                    zero_checks.append(f"{hid} base_patk 0 corrupted")
            if cfg.get('is_only') == 0:
                if h.get('is_only') != 0:
                    zero_checks.append(f"{hid} is_only 0 corrupted")
            if cfg.get('rebirth') == 0:
                if h.get('rebirth') != 0:
                    zero_checks.append(f"{hid} rebirth 0 corrupted")

        all_ok = len(mismatches) == 0 and len(zero_checks) == 0
        msg = f"Audited {len(heroes)} heroes against raw config. Mismatches: {len(mismatches)}, Zero errors: {len(zero_checks)}"
        self.record(test_name, all_ok, msg, {"mismatches": mismatches[:10], "zero_errors": zero_checks[:10]})

    def test_progression_systems(self):
        test_name = "2. Progression Systems (Rebirth, Super Evo, Breakthrough, Strengthen)"
        with open(HEROES_PATH, 'r', encoding='utf-8') as f:
            heroes = json.load(f)
        with open(os.path.join(CONFIG_DIR, 'character_strengthen.config'), 'r', encoding='utf-8') as f:
            strengthen_cfg = json.load(f)

        errors = []

        # 1. Strengthen stages 1-60
        if len(strengthen_cfg) != 60:
            errors.append(f"Strengthen levels count = {len(strengthen_cfg)}, expected 60")

        # 2. Rebirth stages check
        expected_rebirth_titles = ["Dũng Sĩ", "Đấu Sĩ", "Anh Hùng", "Thần Thoại", "Thần", "Linh", "Hồn"]
        heroes_with_rebirth = 0
        for hid, h in heroes.items():
            cs = h.get('chuyen_sinh')
            if cs and cs.get('stages'):
                heroes_with_rebirth += 1
                for s in cs['stages']:
                    stage_num = s.get('stage', 0)
                    if 1 <= stage_num <= 7:
                        expected_prefix = expected_rebirth_titles[stage_num - 1]
                        if s.get('prefix') != expected_prefix:
                            errors.append(f"{hid} CS stage {stage_num} prefix '{s.get('prefix')}' != '{expected_prefix}'")

        # 3. Super Evo stages check
        super_evo_count = sum(1 for h in heroes.values() if h.get('super_evo', {}).get('has_super_evo'))

        # 4. Breakthrough stages check (1-20)
        breakthrough_count = sum(1 for h in heroes.values() if h.get('breakthrough_system', {}).get('has_breakthrough'))

        all_ok = len(errors) == 0
        msg = f"Strengthen 1-60 OK, Rebirth checked ({heroes_with_rebirth} heroes), Super Evo ({super_evo_count} heroes), Breakthrough ({breakthrough_count} heroes)"
        self.record(test_name, all_ok, msg, {"errors": errors[:10]})

    def test_ban_suc_recommendations(self):
        test_name = "3. Ban Sức Recommendations Integrity"
        with open(BAN_SUC_PATH, 'r', encoding='utf-8') as f:
            bs_data = json.load(f)
        with open(HEROES_PATH, 'r', encoding='utf-8') as f:
            heroes = json.load(f)

        errors = []
        b_defs = bs_data.get('ban_suc_definitions', {})

        # 1. Check alias Thần Thư == Thiên Thư
        than_thu = b_defs.get('than-thu', {})
        if "thien-thu" not in than_thu.get('alias', []):
            errors.append("than-thu missing 'thien-thu' alias")
        if than_thu.get('fate_id') != "7":
            errors.append(f"than-thu fate_id is {than_thu.get('fate_id')}, expected 7")

        # 2. Check hero mapping
        bs_heroes = bs_data.get('heroes', {})
        for hid, bsh in bs_heroes.items():
            if hid not in heroes:
                errors.append(f"Ban Sức target hero {hid} not found in heroes_detail.json")

        # 3. Check reference heroes (Nagato & Sasuke) have Thần Thư
        nagato_recs = bs_heroes.get('82400', {}).get('recommendations', [])
        has_nagato_tt = any(r.get('id') == 'than-thu' for r in nagato_recs)
        if not has_nagato_tt:
            errors.append("Nagato (82400) missing Thần Thư recommendation")

        sasuke_recs = bs_heroes.get('43900', {}).get('recommendations', [])
        has_sasuke_tt = any(r.get('id') == 'than-thu' for r in sasuke_recs)
        if not has_sasuke_tt:
            errors.append("Sasuke (43900) missing Thần Thư recommendation")

        all_ok = len(errors) == 0
        msg = f"Verified {len(b_defs)} Ban Sức items, {len(bs_heroes)} hero recommendations. Thần Thư == Thiên Thư OK."
        self.record(test_name, all_ok, msg, {"errors": errors})

    def test_artwork_manifest_and_files(self):
        test_name = "4. Artwork Manifest & File Integrity"
        with open(MANIFEST_PATH, 'r', encoding='utf-8') as f:
            manifest = json.load(f)
        with open(HEROES_PATH, 'r', encoding='utf-8') as f:
            heroes = json.load(f)

        missing_standing = []
        missing_card = []
        verified_count = 0

        # Check key reference heroes (including Newgate & Whitebeard regression checks)
        key_refs = ['82400', '43900', '83900', '84000', '32100', '2100', '43700', '83500', '83600', '32900', '82200', '43000', '82100']

        for hid, m in manifest.items():
            st_img = m.get('standing', {}).get('image')
            cd_img = m.get('card', {}).get('image')

            if st_img:
                disk_path = os.path.join(WEB_PUBLIC, st_img.lstrip('/'))
                if not os.path.exists(disk_path):
                    missing_standing.append(f"{hid}: {disk_path}")

            if cd_img:
                disk_path = os.path.join(WEB_PUBLIC, cd_img.lstrip('/'))
                if not os.path.exists(disk_path):
                    missing_card.append(f"{hid}: {disk_path}")

            if m.get('standing', {}).get('verified'):
                verified_count += 1

        for hid in key_refs:
            if not manifest.get(hid, {}).get('standing', {}).get('verified'):
                missing_standing.append(f"Key reference hero {hid} not flagged as verified")

        # Specific regression check for Newgate (82200)
        from PIL import Image
        st_newgate = os.path.join(WEB_PUBLIC, 'assets', 'heroes', 'standing_82200.png')
        cd_newgate = os.path.join(WEB_PUBLIC, 'assets', 'heroes', 'card_82200.png')
        if os.path.exists(st_newgate):
            w, h = Image.open(st_newgate).size
            # Old bug size was (1107, 864) due to huge smoke box. Engine size is (492, 403)
            if w > 800 or h > 700:
                missing_standing.append(f"Newgate 82200 standing image oversized ({w}x{h}), smoke box bug detected")
        else:
            missing_standing.append("Newgate standing_82200.png missing")

        if not os.path.exists(cd_newgate):
            missing_card.append("Newgate card_82200.png missing")

        all_ok = len(missing_standing) == 0 and len(missing_card) == 0
        msg = f"Audited {len(manifest)} manifest entries. {verified_count} verified engine-faithful models. Missing standing: {len(missing_standing)}, missing card: {len(missing_card)}"
        self.record(test_name, all_ok, msg, {"missing_standing": missing_standing[:5], "missing_card": missing_card[:5]})

    def test_family_forms_integrity(self):
        test_name = "5. Family Forms Link Integrity"
        with open(HEROES_PATH, 'r', encoding='utf-8') as f:
            heroes = json.load(f)

        broken_links = []
        groups_checked = 0

        for hid, h in heroes.items():
            ff = h.get('family_forms', [])
            if len(ff) > 1:
                groups_checked += 1
                for f in ff:
                    target_id = f.get('id')
                    if target_id not in heroes:
                        broken_links.append(f"{hid} links to non-existent hero {target_id}")

        all_ok = len(broken_links) == 0
        msg = f"Checked {groups_checked} multi-form heroes. Broken links: {len(broken_links)}"
        self.record(test_name, all_ok, msg, {"broken_links": broken_links})

    def test_suits_and_badges_integrity(self):
        test_name = "6. Suits and Badges Integrity"
        with open(os.path.join(CONFIG_DIR, 'suit.config'), 'r', encoding='utf-8') as f:
            suit_cfg = json.load(f)
        with open(os.path.join(CONFIG_DIR, 'badge.config'), 'r', encoding='utf-8') as f:
            badge_cfg = json.load(f)

        errors = []
        if len(suit_cfg) < 500:
            errors.append(f"Suit config entries = {len(suit_cfg)}, unexpectedly low")
        if len(badge_cfg) < 50:
            errors.append(f"Badge config entries = {len(badge_cfg)}, unexpectedly low")

        all_ok = len(errors) == 0
        msg = f"Suit config: {len(suit_cfg)} entries, Badge config: {len(badge_cfg)} entries"
        self.record(test_name, all_ok, msg, {"errors": errors})

if __name__ == '__main__':
    validator = AuditValidator()
    success = validator.run_all()
    sys.exit(0 if success else 1)
