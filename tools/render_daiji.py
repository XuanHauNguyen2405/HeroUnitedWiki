import struct, os, re, copy, math
from PIL import Image

def parse_sam(filepath):
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
            # Field 1 = spr_id, Field 2 = cid, Field 3 = depth
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
            # Flash RemoveObject removes object by depth or cid
            # If cid matches, remove
            rem_cid = cmd['cid']
            to_del = [d for d, o in stage.items() if o.get('cid') == rem_cid or d == rem_cid]
            for d in to_del:
                stage.pop(d, None)
        elif cmd['type'] == 'show_frame':
            frames.append(copy.deepcopy(stage))
    return frames

def render_stage_to_image(stage, sprites, frames_dir, scale_factor=2.5, include_effects=True):
    canvas_w, canvas_h = 1600, 1600
    canvas = Image.new('RGBA', (canvas_w, canvas_h), (0, 0, 0, 0))
    origin_x = 800
    origin_y = 800

    sorted_objs = sorted(stage.values(), key=lambda o: o['depth'])

    for obj in sorted_objs:
        s_id = obj['spr_id']
        if s_id == 0: continue
        s_name = sprites.get(s_id)
        if not s_name: continue
        m_name = s_name.replace('.swf', '_')
        png_path = os.path.join(frames_dir, m_name)
        if not os.path.exists(png_path): continue
        
        # Check if it's an effect particle / smoke / aura if include_effects is False
        if not include_effects:
            # Often high depths or specific sprite IDs
            pass
            
        part = Image.open(png_path).convert('RGBA')
        pw, ph = part.size
        if not obj['matrix']: continue
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
        
        canvas_pts = []
        for dx, dy in corners:
            cx = (m0 * dx + m3 * dy + tx) * scale_factor + origin_x
            cy = (m2 * dx + m1 * dy + ty) * scale_factor + origin_y
            canvas_pts.append((cx, cy))
            
        xs = [p[0] for p in canvas_pts]
        ys = [p[1] for p in canvas_pts]
        min_x, max_x = int(math.floor(min(xs))), int(math.ceil(max(xs)))
        min_y, max_y = int(math.floor(min(ys))), int(math.ceil(max(ys)))
        
        bw = max_x - min_x
        bh = max_y - min_y
        if bw <= 0 or bh <= 0: continue
        
        A = m0 * scale_factor
        B = m3 * scale_factor
        C = m2 * scale_factor
        D = m1 * scale_factor
        det = A * D - B * C
        if abs(det) < 1e-6: continue
        
        inv_A =  D / det
        inv_B = -B / det
        inv_C = -C / det
        inv_D =  A / det
        
        dest_corners = [
            (min_x, min_y),
            (min_x, max_y),
            (max_x, max_y),
            (max_x, min_y),
        ]
        
        quad_src = []
        for x_dst, y_dst in dest_corners:
            rx = x_dst - (tx * scale_factor + origin_x)
            ry = y_dst - (ty * scale_factor + origin_y)
            dx = inv_A * rx + inv_B * ry
            dy = inv_C * rx + inv_D * ry
            u = dx + pw / 2.0
            v = dy + ph / 2.0
            quad_src.extend([u, v])
            
        warped = part.transform((bw, bh), Image.Transform.QUAD, quad_src, resample=Image.Resampling.BILINEAR)
        if alpha_mult < 0.99:
            r, g, b, a = warped.split()
            a = a.point(lambda p: int(p * alpha_mult))
            warped.putalpha(a)
            
        canvas.alpha_composite(warped, (min_x, min_y))

    bbox = canvas.getbbox()
    if bbox:
        return canvas.crop((bbox[0]-10, bbox[1]-10, bbox[2]+10, bbox[3]+10))
    return canvas

if __name__ == '__main__':
    sprites, actions = parse_sam('apk_extracted/assets/iphonehd/anim/peien2.swf.sam')
    daiji_frames = simulate_action(actions, 'daiji')
    print(f"Rendered {len(daiji_frames)} daiji frames.")
    for idx in [0, 8, 16, 24]:
        if idx < len(daiji_frames):
            im = render_stage_to_image(daiji_frames[idx], sprites, 'scratch/peien2_frames')
            im.save(f'scratch/nagato_daiji_f{idx}.png')
            print(f"Saved scratch/nagato_daiji_f{idx}.png, size={im.size}")
