import os, struct, zlib, plistlib, re, json, math, argparse, copy
import numpy as np
from PIL import Image

def parse_rect(s):
    nums = [int(n) for n in re.findall(r'-?\d+', s)]
    return nums[0], nums[1], nums[2], nums[3]

def parse_point(s):
    nums = [int(n) for n in re.findall(r'-?\d+', s)]
    return nums[0], nums[1]

def parse_sam(filepath):
    if not os.path.exists(filepath):
        return {}, {}
    with open(filepath, 'rb') as f:
        data = f.read()

    pos = 0
    total = len(data)
    sprites = {}
    actions = {}
    cur_action = 'ROOT'
    actions[cur_action] = []

    while pos < total:
        if pos + 8 > total: break
        tag, subtag = struct.unpack_from('<II', data, pos)
        pos += 8
        if tag == 1:
            spr_id = struct.unpack_from('<I', data, pos)[0]
            pos += 4
            end = data.find(b'\x00', pos)
            sprites[spr_id] = data[pos:end].decode('utf-8', 'ignore')
            pos = end + 1
        elif tag == 2:
            end = data.find(b'\x00', pos)
            cur_action = data[pos:end].decode('utf-8', 'ignore')
            pos = end + 1
            if cur_action not in actions: actions[cur_action] = []
        elif tag == 3:
            spr_id, cid, depth, has_color, has_matrix = struct.unpack_from('<IIIII', data, pos)
            pos += 20
            mat = None
            if has_matrix:
                mat = struct.unpack_from('<ffffff', data, pos)
                pos += 24
            color = None
            if has_color:
                has_add, has_mult = struct.unpack_from('<II', data, pos)
                pos += 8
                mult_vals = None
                add_vals = None
                if has_mult:
                    mult_vals = struct.unpack_from('<IIII', data, pos)
                    pos += 16
                if has_add:
                    add_vals = struct.unpack_from('<IIII', data, pos)
                    pos += 16
                color = {'mult': mult_vals, 'add': add_vals}
            actions[cur_action].append({
                'type': 'place', 'spr_id': spr_id, 'cid': cid, 'depth': depth,
                'matrix': mat, 'color': color
            })
        elif tag == 4:
            cid = struct.unpack_from('<I', data, pos)[0]
            pos += 4
            actions[cur_action].append({'type': 'remove', 'cid': cid})
        elif tag == 5:
            actions[cur_action].append({'type': 'show_frame'})
        elif tag == 6:
            pos += 16
        elif tag == 7:
            end = data.find(b'\x00', pos)
            pos = end + 1
        else:
            break

    return sprites, actions

def simulate_action(actions, action_name='daiji'):
    cmds = actions.get(action_name, [])
    if not cmds:
        for act in ['daiji', 'dengchang', 'qianjin', 'beiji', 'gongji1']:
            if act in actions and actions[act]:
                cmds = actions[act]
                break
    if not cmds and actions:
        cmds = next(iter(actions.values()))

    stage = {}
    frames = []
    for cmd in cmds:
        if cmd['type'] == 'place':
            depth = cmd['depth']
            if depth not in stage:
                stage[depth] = {
                    'depth': depth,
                    'spr_id': cmd['spr_id'],
                    'cid': cmd['cid'],
                    'matrix': cmd['matrix'],
                    'color': cmd['color']
                }
            else:
                if cmd['spr_id'] != 0:
                    stage[depth]['spr_id'] = cmd['spr_id']
                stage[depth]['cid'] = cmd['cid']
                if cmd['matrix'] is not None:
                    stage[depth]['matrix'] = cmd['matrix']
                if cmd['color'] is not None:
                    stage[depth]['color'] = cmd['color']
        elif cmd['type'] == 'remove':
            rem_cid = cmd['cid']
            to_del = [d for d, o in stage.items() if o.get('cid') == rem_cid or d == rem_cid]
            for d in to_del:
                stage.pop(d, None)
        elif cmd['type'] == 'show_frame':
            frames.append(copy.deepcopy(stage))
            if len(frames) >= 1:
                # Often frame 0 or 1 is the complete rest pose
                break
    if not frames and stage:
        frames.append(stage)
    return frames

def render_anim(anim_name, anim_dirs=None):
    if anim_dirs is None:
        anim_dirs = [
            'output/apk_extracted/assets/iphonehd/anim',
            'Resources/iphonehd/anim',
            'public/assets/iphonehd/anim'
        ]

    plist_path = None
    sam_path = None
    found_dir = None

    for ad in anim_dirs:
        p_sam = os.path.join(ad, f"{anim_name}.swf.sam")
        p_plist = os.path.join(ad, f"{anim_name}.plist")
        if os.path.exists(p_sam) and os.path.exists(p_plist):
            plist_path = p_plist
            sam_path = p_sam
            found_dir = ad
            break

    if not plist_path or not sam_path:
        return None

    # Load plist to find texture file name
    with open(plist_path, 'rb') as f:
        pl = plistlib.load(f)

    meta = pl.get('metadata', {})
    tex_name = meta.get('realTextureFileName') or meta.get('textureFileName') or f"{anim_name}.pvr.ccz"

    # Search for texture in found_dir, or any anim_dir
    pvr_path = os.path.join(found_dir, tex_name)
    if not os.path.exists(pvr_path):
        pvr_path = os.path.join(found_dir, f"{anim_name}-hd.pvr.ccz")
    if not os.path.exists(pvr_path):
        pvr_path = os.path.join(found_dir, f"{anim_name}.pvr.ccz")

    if not os.path.exists(pvr_path):
        for ad in anim_dirs:
            candidate = os.path.join(ad, tex_name)
            if os.path.exists(candidate):
                pvr_path = candidate
                break
            candidate = os.path.join(ad, f"{anim_name}-hd.pvr.ccz")
            if os.path.exists(candidate):
                pvr_path = candidate
                break
            candidate = os.path.join(ad, f"{anim_name}.pvr.ccz")
            if os.path.exists(candidate):
                pvr_path = candidate
                break

    if not os.path.exists(pvr_path):
        return None

    # 1. Decompress PVR
    with open(pvr_path, 'rb') as f:
        data = f.read()
    decomp = zlib.decompress(data[16:])
    header = struct.unpack('<13I', decomp[:52])
    pvr_h, pvr_w = header[1], header[2]
    fmt = header[4] & 0xFF
    bpp = header[6]

    if bpp == 16 or fmt == 0x10:
        # RGBA4444 unpacking
        arr = np.frombuffer(decomp[52:52 + pvr_w * pvr_h * 2], dtype=np.uint16)
        r = (((arr >> 12) & 0xF) * 17).astype(np.uint8)
        g = (((arr >> 8) & 0xF) * 17).astype(np.uint8)
        b = (((arr >> 4) & 0xF) * 17).astype(np.uint8)
        a = ((arr & 0xF) * 17).astype(np.uint8)
        rgba = np.stack([r, g, b, a], axis=-1)
        atlas = Image.fromarray(rgba.reshape((pvr_h, pvr_w, 4)), 'RGBA')
    else:
        # RGBA8888
        atlas = Image.frombytes('RGBA', (pvr_w, pvr_h), decomp[52:52 + pvr_w * pvr_h * 4])

    frames_mem = {}
    for name, f_info in pl['frames'].items():
        fx, fy, fw, fh = parse_rect(f_info['frame'])
        rotated = f_info.get('rotated', False)
        sw, sh = parse_point(f_info['sourceSize'])
        cx, cy, cw, ch = parse_rect(f_info['sourceColorRect'])
        if rotated:
            crop = atlas.crop((fx, fy, fx + fh, fy + fw))
            cropped_img = crop.transpose(Image.Transpose.ROTATE_90)
        else:
            cropped_img = atlas.crop((fx, fy, fx + fw, fy + fh))
        out = Image.new('RGBA', (sw, sh), (0, 0, 0, 0))
        out.paste(cropped_img, (cx, cy))
        clean_name = name.replace('.swf', '_')
        frames_mem[clean_name] = out

    # 3. Parse SAM and simulate daiji
    import copy
    sprites, actions = parse_sam(sam_path)
    frames = simulate_action(actions, 'daiji')
    if not frames:
        return None
    stage = frames[0]

    # 4. Composite onto canvas
    scale_factor = 2.5
    canvas_w, canvas_h = 1600, 1600
    canvas = Image.new('RGBA', (canvas_w, canvas_h), (0, 0, 0, 0))
    origin_x, origin_y = 800, 800

    sorted_objs = sorted(stage.values(), key=lambda o: o['depth'])

    for obj in sorted_objs:
        s_id = obj['spr_id']
        if s_id == 0: continue
        s_name = sprites.get(s_id)
        if not s_name: continue
        m_name = s_name.replace('.swf', '_')
        part = frames_mem.get(m_name)
        if not part or not obj['matrix']: continue
        
        pw, ph = part.size
        m0, m1, m2, m3, tx, ty = obj['matrix']
        alpha_mult = 1.0
        if obj['color'] and obj['color']['mult']:
            alpha_mult = obj['color']['mult'][3] / 256.0
            if alpha_mult < 0.03: continue

        corners = [
            (-pw/2.0, -ph/2.0),
            ( pw/2.0, -ph/2.0),
            ( pw/2.0,  ph/2.0),
            (-pw/2.0,  ph/2.0),
        ]
        canvas_pts = [
            ((m0 * dx + m3 * dy + tx) * scale_factor + origin_x,
             (m2 * dx + m1 * dy + ty) * scale_factor + origin_y)
            for dx, dy in corners
        ]
        xs = [p[0] for p in canvas_pts]
        ys = [p[1] for p in canvas_pts]
        min_x, max_x = int(math.floor(min(xs))), int(math.ceil(max(xs)))
        min_y, max_y = int(math.floor(min(ys))), int(math.ceil(max(ys)))
        bw = max_x - min_x
        bh = max_y - min_y
        if bw <= 0 or bh <= 0: continue

        A, B, C, D = m0 * scale_factor, m3 * scale_factor, m2 * scale_factor, m1 * scale_factor
        det = A * D - B * C
        if abs(det) < 1e-6: continue

        inv_A, inv_B, inv_C, inv_D = D / det, -B / det, -C / det, A / det
        dest_corners = [(min_x, min_y), (min_x, max_y), (max_x, max_y), (max_x, min_y)]
        quad_src = []
        for x_dst, y_dst in dest_corners:
            rx = x_dst - (tx * scale_factor + origin_x)
            ry = y_dst - (ty * scale_factor + origin_y)
            dx = inv_A * rx + inv_B * ry
            dy = inv_C * rx + inv_D * ry
            quad_src.extend([dx + pw / 2.0, dy + ph / 2.0])

        warped = part.transform((bw, bh), Image.Transform.QUAD, quad_src, resample=Image.Resampling.BILINEAR)
        if alpha_mult < 0.99:
            r, g, b, a = warped.split()
            a = a.point(lambda p: int(p * alpha_mult))
            warped.putalpha(a)
        canvas.alpha_composite(warped, (min_x, min_y))

    bbox = canvas.getbbox()
    if bbox:
        return canvas.crop((max(0, bbox[0]-10), max(0, bbox[1]-10), min(canvas_w, bbox[2]+10), min(canvas_h, bbox[3]+10)))
    return canvas

def batch_process(output_dirs=['public/assets/heroes', 'web/public/assets/heroes']):
    for d in output_dirs:
        os.makedirs(d, exist_ok=True)

    heroes = {}
    if os.path.exists('config/character_detail.config'):
        with open('config/character_detail.config', 'r', encoding='utf-8') as f:
            cd = json.load(f)
            for hid, h in cd.items():
                heroes[str(hid)] = {'animation': h.get('animation')}
    if os.path.exists('output/heroes.json'):
        with open('output/heroes.json', 'r', encoding='utf-8') as f:
            for hid, h in json.load(f).items():
                anim = h.get('assets', {}).get('animation', {}).get('ref')
                if anim:
                    heroes[str(hid)] = {'animation': anim}

    img_dirs = [
        'output/apk_extracted/assets/iphonehd/img',
        'Resources/iphonehd/img',
        'public/assets/iphonehd/img'
    ]
    success = 0
    fallback = 0
    missing = 0

    print(f"Starting batch extraction for {len(heroes)} heroes...")
    for hid, h in sorted(heroes.items(), key=lambda x: int(x[0]) if x[0].isdigit() else 0):
        anim_ref = h.get('animation')
        im = None
        if anim_ref:
            try:
                im = render_anim(anim_ref)
            except Exception as e:
                pass

        if not im and anim_ref:
            # Fallback to image_{anim_ref}.png if anim cannot be rendered
            for img_dir in img_dirs:
                fb_path = os.path.join(img_dir, f"image_{anim_ref}.png")
                if os.path.exists(fb_path):
                    try:
                        im = Image.open(fb_path).convert('RGBA')
                        fallback += 1
                        break
                    except Exception:
                        pass

        if im:
            success += 1
            for d in output_dirs:
                out_file = os.path.join(d, f"full_{hid}.png")
                im.save(out_file)
        else:
            missing += 1

    print(f"Batch completed: {success} rendered (including {fallback} image fallbacks), {missing} missing.")

def update_web_data():
    data_files = ['web/src/data/heroes_detail.json', 'web/src/data/heroes_catalog.json']
    heroes_dir = 'web/public/assets/heroes'

    # Update heroes_detail.json
    detail_path = 'web/src/data/heroes_detail.json'
    if os.path.exists(detail_path):
        with open(detail_path, 'r', encoding='utf-8') as f:
            details = json.load(f)
        count = 0
        for hid, d in details.items():
            img_file = f"full_{hid}.png"
            if os.path.exists(os.path.join(heroes_dir, img_file)):
                d['full_image'] = f"/assets/heroes/{img_file}"
                count += 1
            else:
                d['full_image'] = None
        with open(detail_path, 'w', encoding='utf-8') as f:
            json.dump(details, f, ensure_ascii=False)
        print(f"Updated heroes_detail.json with {count} full_image links.")

    # Update heroes_catalog.json
    catalog_path = 'web/src/data/heroes_catalog.json'
    if os.path.exists(catalog_path):
        with open(catalog_path, 'r', encoding='utf-8') as f:
            catalog = json.load(f)
        count = 0
        for item in catalog:
            hid = str(item.get('id', ''))
            img_file = f"full_{hid}.png"
            if os.path.exists(os.path.join(heroes_dir, img_file)):
                item['full_image'] = f"/assets/heroes/{img_file}"
                count += 1
            else:
                item['full_image'] = None
        with open(catalog_path, 'w', encoding='utf-8') as f:
            json.dump(catalog, f, ensure_ascii=False)
        print(f"Updated heroes_catalog.json with {count} full_image links.")

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--test-nagato', action='store_true', help='Test Nagato 82400 and Pain 43100 only')
    parser.add_argument('--all', action='store_true', help='Process all heroes in batch')
    parser.add_argument('--update-web', action='store_true', help='Update web json datasets')
    args = parser.parse_args()

    if args.test_nagato:
        print("Rendering Nagato (peien2)...")
        im_n = render_anim('peien2')
        if im_n:
            im_n.save('web/public/assets/heroes/full_82400.png')
            im_n.save('public/assets/heroes/full_82400.png')
            print("Saved full_82400.png:", im_n.size)
        print("Rendering Pain (peien)...")
        im_p = render_anim('peien')
        if im_p:
            im_p.save('web/public/assets/heroes/full_43100.png')
            im_p.save('public/assets/heroes/full_43100.png')
            print("Saved full_43100.png:", im_p.size)
        update_web_data()
    elif args.all:
        batch_process()
        update_web_data()
    else:
        print("Use --test-nagato or --all")
