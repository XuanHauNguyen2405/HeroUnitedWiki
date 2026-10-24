"""Engine-faithful renderer for *.swf.sam puppet animations.

Formula reverse-engineered from lib/armeabi-v7a/libjinqu.so (APK, read-only):
  zcAnimSprite::setMatrix (0x165f38):
      pos.x = tx * 0.5
      pos.y = size.height - ty * 0.5        (size = anim size from SAM tag 6, e.g. 200x250)
      flipX  -> negate m0, m3 ; pos.x = size.width - pos.x
  zcAnimSprite::updateAnimMatrix (0x1660b4), applied to the sprite quad
  (anchor 0.5, y-up, dx/dy = vertex - pos):
      x' = m0*dx + m3*dy + pos.x
      y' = m2*dx + m1*dy + pos.y
  Color transform: multiplier (r,g,b,a)/256 (+ add, ignored here except alpha).

Usage:
  python tools/render_engine.py <anim> [action] [frame|all|sheet] [out]
"""
import os, sys, math, struct, zlib, plistlib, copy
import numpy as np
from PIL import Image

ANIM_DIRS = [
    'output/apk_extracted/assets/iphonehd/anim',
    'Resources/iphonehd/anim',
    'public/assets/iphonehd/anim',
]


def _rect(s):
    n = [float(x) for x in s.replace('{', '').replace('}', '').split(',')]
    return [int(v) for v in n]


def find_anim(anim):
    for d in ANIM_DIRS:
        sam = os.path.join(d, f'{anim}.swf.sam')
        pl = os.path.join(d, f'{anim}.plist')
        if os.path.exists(sam) and os.path.exists(pl):
            return d, sam, pl
    return None, None, None


def load_atlas(d, pl_path, anim):
    with open(pl_path, 'rb') as f:
        pl = plistlib.load(f)
    meta = pl.get('metadata', {})
    names = [meta.get('realTextureFileName'), meta.get('textureFileName'),
             f'{anim}-hd.pvr.ccz', f'{anim}.pvr.ccz']
    pvr = next((os.path.join(dd, n) for n in names if n for dd in [d] + ANIM_DIRS
                if os.path.exists(os.path.join(dd, n))), None)
    if not pvr:
        raise FileNotFoundError(f'texture for {anim}')
    data = open(pvr, 'rb').read()
    dec = zlib.decompress(data[16:])
    h = struct.unpack('<13I', dec[:52])
    H, W, fmt, bpp = h[1], h[2], h[4] & 0xFF, h[6]
    if bpp == 16 or fmt == 0x10:
        arr = np.frombuffer(dec[52:52 + W * H * 2], dtype=np.uint16)
        rgba = np.stack([((arr >> s) & 0xF) * 17 for s in (12, 8, 4, 0)], -1).astype(np.uint8)
        atlas = Image.fromarray(rgba.reshape(H, W, 4), 'RGBA')
    else:
        atlas = Image.frombytes('RGBA', (W, H), dec[52:52 + W * H * 4])
    parts = {}
    for name, fi in pl['frames'].items():
        fx, fy, fw, fh = _rect(fi['frame'])
        sw, sh = _rect(fi['sourceSize'])
        cx, cy, _, _ = _rect(fi['sourceColorRect'])
        if fi.get('rotated'):
            img = atlas.crop((fx, fy, fx + fh, fy + fw)).transpose(Image.Transpose.ROTATE_90)
        else:
            img = atlas.crop((fx, fy, fx + fw, fy + fh))
        out = Image.new('RGBA', (sw, sh))
        out.paste(img, (cx, cy))
        parts[name] = out
    return parts, pvr


def parse_sam(path):
    data = open(path, 'rb').read()
    pos, sprites, actions, cur, size = 0, {}, {'ROOT': []}, 'ROOT', (200, 250)
    while pos + 8 <= len(data):
        tag, _ = struct.unpack_from('<II', data, pos); pos += 8
        if tag == 1:
            sid = struct.unpack_from('<I', data, pos)[0]; pos += 4
            e = data.find(b'\x00', pos); sprites[sid] = data[pos:e].decode('utf-8', 'ignore'); pos = e + 1
        elif tag == 2:
            e = data.find(b'\x00', pos); cur = data[pos:e].decode('utf-8', 'ignore'); pos = e + 1
            actions.setdefault(cur, [])
        elif tag == 3:
            sid, cid, depth, hc, hm = struct.unpack_from('<IIIII', data, pos); pos += 20
            mat = None
            if hm:
                mat = struct.unpack_from('<ffffff', data, pos); pos += 24
            col = None
            if hc:
                ha, hmu = struct.unpack_from('<II', data, pos); pos += 8
                mu = ad = None
                if hmu:
                    mu = struct.unpack_from('<iiii', data, pos); pos += 16
                if ha:
                    ad = struct.unpack_from('<iiii', data, pos); pos += 16
                col = {'mult': mu, 'add': ad}
            actions[cur].append(('place', sid, cid, depth, mat, col))
        elif tag == 4:
            cid = struct.unpack_from('<I', data, pos)[0]; pos += 4
            actions[cur].append(('remove', cid))
        elif tag == 5:
            actions[cur].append(('show',))
        elif tag == 6:
            w, hh = struct.unpack_from('<II', data, pos); size = (w, hh); pos += 16
        elif tag == 7:
            e = data.find(b'\x00', pos); pos = e + 1
        else:
            break
    return sprites, actions, size


def simulate(actions, action):
    stage, frames = {}, []
    for c in actions.get(action, []):
        if c[0] == 'place':
            _, sid, cid, depth, mat, col = c
            o = stage.setdefault(depth, {'spr': sid, 'cid': cid, 'mat': mat, 'col': col})
            if sid:
                o['spr'] = sid
            o['cid'] = cid
            if mat is not None:
                o['mat'] = mat
            if col is not None:
                o['col'] = col
        elif c[0] == 'remove':
            for d in [d for d, o in stage.items() if o['cid'] == c[1] or d == c[1]]:
                stage.pop(d)
        else:
            frames.append(copy.deepcopy(stage))
    return frames


def render_frame(stage, sprites, parts, size, scale=2.0, flip_x=False):
    AW, AH = size
    CW, CH = int(AW * scale * 5), int(AH * scale * 5)
    canvas = Image.new('RGBA', (CW, CH))
    ox, oy = CW / 2 - AW * scale, CH / 2 + AH * scale  # pixel of engine (0,0)
    for depth in sorted(stage):
        o = stage[depth]
        part = parts.get(sprites.get(o['spr'], ''))
        if part is None or not o['mat']:
            continue
        m0, m1, m2, m3, tx, ty = o['mat']
        # Units = hd texture pixels. Engine: pos_pt = tx*0.5 with sprite size_pt = px/2
        # (content scale 2 for iphonehd) => in pixels pos = tx, y-up.
        px, py = tx, 2 * AH - ty
        if flip_x:
            m0, m3, px = -m0, -m3, 2 * AW - px
        det = m0 * m1 - m3 * m2
        if abs(det) < 1e-6:
            continue
        am, ar = 1.0, 0
        if o['col'] and o['col']['mult']:
            am = o['col']['mult'][3] / 256.0
        if o['col'] and o['col']['add']:
            ar = o['col']['add'][3]
        if am <= 0.01 and ar <= 0:
            continue
        pw, ph = part.size
        pts = []
        for dx, dy in ((-pw / 2, -ph / 2), (pw / 2, -ph / 2), (pw / 2, ph / 2), (-pw / 2, ph / 2)):
            X, Y = m0 * dx + m3 * dy + px, m2 * dx + m1 * dy + py
            pts.append((ox + X * scale, oy - Y * scale))
        x0, x1 = int(math.floor(min(p[0] for p in pts))), int(math.ceil(max(p[0] for p in pts)))
        y0, y1 = int(math.floor(min(p[1] for p in pts))), int(math.ceil(max(p[1] for p in pts)))
        if x1 <= x0 or y1 <= y0:
            continue
        quad = []
        for qx, qy in ((x0, y0), (x0, y1), (x1, y1), (x1, y0)):
            X, Y = (qx - ox) / scale - px, (oy - qy) / scale - py
            dx, dy = (m1 * X - m3 * Y) / det, (-m2 * X + m0 * Y) / det
            quad += [dx + pw / 2, ph / 2 - dy]
        w = part.transform((x1 - x0, y1 - y0), Image.Transform.QUAD, quad,
                           resample=Image.Resampling.BICUBIC)
        if am < 0.995 or ar:
            a = np.asarray(w.split()[3], dtype=np.float32)
            a = np.clip(a * am + ar * (a > 0), 0, 255).astype(np.uint8)
            w.putalpha(Image.fromarray(a))
        canvas.alpha_composite(w, (x0, y0)) if x0 >= 0 and y0 >= 0 else canvas.paste(
            Image.alpha_composite(canvas.crop((x0, y0, x1, y1)), w), (x0, y0))
    return canvas, (ox, oy)


def render(anim, action='daiji', frame=0, scale=1.0, crop=True):
    d, sam, pl = find_anim(anim)
    if not sam:
        raise FileNotFoundError(f'{anim}.swf.sam / .plist not found in {ANIM_DIRS}')
    parts, pvr = load_atlas(d, pl, anim)
    sprites, actions, size = parse_sam(sam)
    frames = simulate(actions, action)
    img, _ = render_frame(frames[frame], sprites, parts, size, scale)
    if crop and img.getbbox():
        b = img.getbbox()
        img = img.crop((b[0] - 8, b[1] - 8, b[2] + 8, b[3] + 8))
    return img, {'sam': sam, 'plist': pl, 'texture': pvr, 'size': size,
                 'action': action, 'frame': frame, 'frames_total': len(frames)}


def sheet(anim, action='daiji', cols=6, cell=260):
    d, sam, pl = find_anim(anim)
    parts, _ = load_atlas(d, pl, anim)
    sprites, actions, size = parse_sam(sam)
    frames = simulate(actions, action)
    idx = list(range(0, len(frames), max(1, len(frames) // (cols * 2))))[:cols * 2]
    rows = (len(idx) + cols - 1) // cols
    out = Image.new('RGBA', (cols * cell, rows * cell), (40, 30, 20, 255))
    for k, i in enumerate(idx):
        im, _ = render_frame(frames[i], sprites, parts, size, 1.0)
        b = im.getbbox()
        if b:
            im = im.crop(b)
        im.thumbnail((cell - 10, cell - 24))
        x, y = (k % cols) * cell, (k // cols) * cell
        out.alpha_composite(im, (x + (cell - im.width) // 2, y + 20 + (cell - 24 - im.height) // 2))
    return out, idx


if __name__ == '__main__':
    a = sys.argv[1]
    act = sys.argv[2] if len(sys.argv) > 2 else 'daiji'
    fr = sys.argv[3] if len(sys.argv) > 3 else '0'
    out = sys.argv[4] if len(sys.argv) > 4 else f'scratch/engine_{a}_{act}_{fr}.png'
    if fr == 'sheet':
        im, idx = sheet(a, act)
        im.save(out); print(out, 'frames', idx)
    else:
        im, info = render(a, act, int(fr))
        im.save(out); print(out, im.size, info)
