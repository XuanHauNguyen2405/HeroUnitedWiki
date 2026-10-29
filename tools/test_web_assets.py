"""Regression: source-data rebuild must preserve newer engine-rendered artwork."""
import tempfile
import unittest
from pathlib import Path
from prepare_web_data import copy_web_images


class AssetRebuildTest(unittest.TestCase):
    def test_preserve_engine_assets_but_update_regular_source_images(self):
        with tempfile.TemporaryDirectory(prefix='sahht-assets-test-') as directory:
            root = Path(directory).resolve()
            source, target = root / 'source', root / 'web'
            for folder in (source, target):
                (folder / 'heroes').mkdir(parents=True)
            for name in ('full_82200.png', 'standing_82200.png', 'card_82200.png'):
                (source / 'heroes' / name).write_bytes(b'obsolete staging export')
                (target / 'heroes' / name).write_bytes(b'verified engine render')
            (source / 'icon.png').write_bytes(b'current icon')
            (target / 'icon.png').write_bytes(b'old')
            copy_web_images(str(source), str(target))
            for name in ('full_82200.png', 'standing_82200.png', 'card_82200.png'):
                self.assertEqual((target / 'heroes' / name).read_bytes(), b'verified engine render')
            self.assertEqual((target / 'icon.png').read_bytes(), b'current icon')


if __name__ == '__main__':
    unittest.main()
