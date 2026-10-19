import struct

with open('apk_extracted/assets/iphonehd/anim/peien2.swf.sam', 'rb') as f:
    f.seek(0x36)
    data = f.read(300)

pos = 0
while pos < len(data):
    null_idx = data.find(b'\x00', pos)
    if null_idx != -1 and null_idx - pos > 3 and null_idx - pos < 40 and all(32 <= b <= 126 for b in data[pos:null_idx]):
        s = data[pos:null_idx].decode('ascii')
        print(f"{pos:#04x}: str='{s}'")
        pos = null_idx + 1
    else:
        if pos + 4 <= len(data):
            val = struct.unpack('<I', data[pos:pos+4])[0]
            fval = struct.unpack('<f', data[pos:pos+4])[0]
            print(f"{pos:#04x}: int={val:10} (float={fval:10.4f})")
            pos += 4
        else:
            break
