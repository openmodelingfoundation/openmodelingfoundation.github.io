"""Exercise corruption cases using disposable edition bundles."""
import hashlib
import json
from pathlib import Path
import tempfile
import unittest
from check_standard_archives import verify


class Archives(unittest.TestCase):
    def test_corruption(self):
        for mutation in ('none', 'changed', 'missing', 'extra', 'incomplete'):
            with self.subTest(mutation=mutation), tempfile.TemporaryDirectory() as tmp:
                root = Path(tmp)
                edition = root / 'versions/draft-1'
                edition.mkdir(parents=True)
                files = []
                for name in ('index.md', 'download.txt'):
                    data = b'preserved'
                    (edition / name).write_bytes(data)
                    files.append(dict(path=name, bytes=len(data), sha256=hashlib.sha256(data).hexdigest()))
                (edition / 'manifest.json').write_text(json.dumps(dict(schema_version=1, edition_id='draft-1', files=files)))
                if mutation == 'changed':
                    (edition / 'download.txt').write_text('changed')
                elif mutation == 'missing':
                    (edition / 'download.txt').unlink()
                elif mutation == 'extra':
                    (edition / 'extra.txt').touch()
                elif mutation == 'incomplete':
                    orphan = root / 'versions/draft-2'
                    orphan.mkdir()
                    (orphan / 'download.txt').touch()
                if mutation == 'none':
                    self.assertEqual(verify(root), 1)
                else:
                    with self.assertRaises((ValueError, OSError)):
                        verify(root)


if __name__ == '__main__':
    unittest.main()
