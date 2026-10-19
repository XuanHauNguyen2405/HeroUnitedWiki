import struct

with open('apk_extracted/assets/iphonehd/anim/peien2.swf.sam', 'rb') as f:
    data = f.read()

idx = data.find(b'daiji\x00')
print(f"daiji found at {idx:#x}")

# Let's inspect the stream from idx
pos = idx + len(b'daiji\x00')

# Read action header
# In dengchang, after name was: start_frame(int), end_frame(int), num_layers(int)
# But wait, in daiji, let's see what is immediately after 'daiji\0'
print("Bytes after daiji (64 bytes):", data[pos:pos+64].hex())

# Let's parse records
# Each record starts with 3, then length (44 or 84 or similar)
records = []
while pos < idx + 20000: # inspect first few KB
    if pos + 8 > len(data): break
    tag, rec_len = struct.unpack('<II', data[pos:pos+8])
    if tag == 3 and rec_len in (44, 84):
        payload = data[pos+8 : pos+8+rec_len]
        pos += 8 + rec_len
        # parse payload
        if rec_len == 44:
            spr_id, f_start, f_end, depth, visible = struct.unpack('<IIIII', payload[:20])
            m00, m01, m10, m11, tx, ty = struct.unpack('<ffffff', payload[20:44])
            records.append({
                'spr_id': spr_id, 'f_start': f_start, 'f_end': f_end,
                'depth': depth, 'visible': visible,
                'm': (m00, m01, m10, m11, tx, ty),
                'color': None
            })
        elif rec_len == 84:
            spr_id, f_start, f_end, depth, visible = struct.unpack('<IIIII', payload[:20])
            m00, m01, m10, m11, tx, ty = struct.unpack('<ffffff', payload[20:44])
            # color transform follows
            color_data = struct.unpack('<10I', payload[44:84])
            records.append({
                'spr_id': spr_id, 'f_start': f_start, 'f_end': f_end,
                'depth': depth, 'visible': visible,
                'm': (m00, m01, m10, m11, tx, ty),
                'color': color_data
            })
    else:
        # Check if next byte is tag 3 or string
        # Let's see what is at pos
        # print(f"Unknown at pos={pos:#x}: tag={tag}, rec_len={rec_len}")
        pos += 1

print(f"Parsed {len(records)} records in daiji!")
if records:
    # Let's inspect frame 1 of daiji
    frame1 = [r for r in records if r['f_start'] <= 1 <= r['f_end']]
    print(f"Records active at frame 1: {len(frame1)}")
    for r in frame1[:20]:
        print(f"  spr_id={r['spr_id']:3}, depth={r['depth']:2}, m={tuple(round(x, 2) for x in r['m'])}")
