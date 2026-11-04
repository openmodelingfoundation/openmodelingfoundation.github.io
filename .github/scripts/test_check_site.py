"""Verify multiple editions and actionable, aggregated failure diagnostics."""
import hashlib
import json
from pathlib import Path
import tempfile
import unittest

from check_site import check


class SiteChecks(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)
        self.output = self.root / 'public'
        self.source = self.root / 'content'
        self.feedback = 'https://github.com/openmodelingfoundation/rfcs/discussions/2'
        self.history = '/preview/standards/documentation/versions/'
        self.downloads = []
        for edition in ('draft-1', 'draft-2'):
            name = f'standards/documentation/versions/{edition}'
            source = self.source / name
            source.mkdir(parents=True)
            files = [dict(path='index.md'), dict(path='definition.pdf', sha256=hashlib.sha256(b'original').hexdigest())]
            (source / 'manifest.json').write_text(json.dumps(dict(files=files, discussion_url=self.feedback)))
            href = '/preview/' + name + '/definition.pdf'
            self.write_page(name, True, [self.history, href])
            download = self.output / name / 'definition.pdf'
            download.write_bytes(b'original')
            self.downloads.append(download)
        self.write_page('standards/documentation', True, [self.history, self.history + 'draft-2/definition.pdf'])
        for name in ('standards/documentation/versions', 'standards/reusability', 'working-groups/standards',
                     'working-groups/standards/drafts/documentation'):
            self.write_page(name, False, [])

    def write_page(self, name, standard, links):
        path = self.output / name / 'index.html'
        path.parent.mkdir(parents=True, exist_ok=True)
        classes = 'd-none d-xl-flex' if standard else 'd-flex'
        html = f'<aside class="td-sidebar-toc {classes}"></aside>'
        if standard:
            html += '<details class="omf-standard__mobile-toc"></details>'
            html += f'<a class="btn-primary" href="{self.feedback}">Feedback</a>'
        html += ''.join(f'<a href="{link}">Link</a>' for link in links)
        path.write_text(html)
        return path

    def test_two_editions(self):
        errors, pages, downloads = check(self.output, self.source)
        self.assertEqual(errors, [])
        self.assertEqual((pages, downloads), (7, 2))

    def test_collects_missing_and_changed_downloads(self):
        self.downloads[0].unlink()
        self.downloads[1].write_bytes(b'changed')
        errors, _, _ = check(self.output, self.source)
        self.assertTrue(any('cannot read download' in error for error in errors))
        self.assertTrue(any('checksum mismatch' in error for error in errors))

    def test_footer_link_does_not_replace_primary_feedback(self):
        path = self.output / 'standards/documentation/index.html'
        path.write_text(path.read_text().replace('class="btn-primary"', 'class="footer-link"') + '<p id="duplicate"></p><p id="duplicate"></p>')
        errors, _, _ = check(self.output, self.source)
        self.assertTrue(any('primary feedback action' in error for error in errors))
        self.assertTrue(any('duplicate HTML IDs' in error for error in errors))

    def test_missing_page_does_not_abort_other_checks(self):
        (self.output / 'working-groups/standards/index.html').unlink()
        self.downloads[1].unlink()
        errors, _, _ = check(self.output, self.source)
        self.assertTrue(any('cannot read rendered page' in error for error in errors))
        self.assertTrue(any('cannot read download' in error for error in errors))


if __name__ == '__main__':
    unittest.main()
