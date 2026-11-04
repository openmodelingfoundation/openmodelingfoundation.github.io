"""Check navigation and every archived download in a /preview/ render."""
from collections import Counter
from html.parser import HTMLParser
from pathlib import Path
import hashlib
import json
import sys


class Page(HTMLParser):
    def __init__(self, text):
        super().__init__()
        self.sidebar_classes = set()
        self.mobile_toc = False
        self.ids = []
        self.links = []
        self.feedback_links = []
        self.feed(text)

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        classes = set(attrs.get('class', '').split())
        if 'td-sidebar-toc' in classes:
            self.sidebar_classes = classes
        if 'omf-standard__mobile-toc' in classes:
            self.mobile_toc = True
        if 'id' in attrs:
            self.ids.append(attrs['id'])
        if tag == 'a':
            self.links.append(attrs.get('href', ''))
            if 'btn-primary' in classes:
                self.feedback_links.append(attrs.get('href', ''))


def check(output, source=Path('content/en')):
    errors = []
    pages = {}

    def require(condition, location, message):
        if not condition:
            errors.append(f'{location}: {message}')

    def page(name, standard, feedback=None):
        try:
            parsed = Page((output / name / 'index.html').read_text())
        except OSError as error:
            errors.append(f'{name}: cannot read rendered page: {error}')
            return None
        pages[name] = parsed
        expected = {'d-none', 'd-xl-flex'} if standard else {'d-flex'}
        require(expected <= parsed.sidebar_classes, name,
                f'sidebar missing expected classes {sorted(expected)}')
        require(('d-none' in parsed.sidebar_classes) == standard, name,
                'sidebar visibility does not match the page layout')
        require(parsed.mobile_toc == standard, name, 'incorrect mobile TOC presence')
        duplicates = [key for key, count in Counter(parsed.ids).items() if count > 1]
        require(not duplicates, name, f'duplicate HTML IDs: {duplicates}')
        if feedback:
            require(feedback in parsed.feedback_links, name,
                    f'primary feedback action must point to {feedback}')
        return parsed

    current = page('standards/documentation', True,
                   'https://github.com/openmodelingfoundation/rfcs/discussions/2')
    for name in ('standards/documentation/versions', 'standards/reusability',
                 'working-groups/standards', 'working-groups/standards/drafts/documentation'):
        page(name, False)

    manifests = sorted((source / 'standards').glob('**/versions/*/manifest.json'))
    require(bool(manifests), source, 'no edition manifests found')
    definition_links = []
    download_count = 0
    for manifest_path in manifests:
        name = manifest_path.parent.relative_to(source).as_posix()
        try:
            manifest = json.loads(manifest_path.read_text())
            entries = manifest['files']
        except (OSError, ValueError, KeyError) as error:
            errors.append(f'{manifest_path}: cannot read manifest: {error}')
            continue
        archived = page(name, True, manifest.get('discussion_url'))
        history = '/preview/' + manifest_path.parent.parent.relative_to(source).as_posix() + '/'
        if archived:
            require(history in archived.links, name, f'missing history link {history}')
        for entry in entries:
            if entry['path'] == 'index.md':
                continue
            served = output / name / entry['path']
            href = '/preview/' + name + '/' + entry['path']
            if archived:
                require(href in archived.links, name, f'missing download link {href}')
            try:
                digest = hashlib.sha256(served.read_bytes()).hexdigest()
                require(digest == entry['sha256'], served, 'download checksum mismatch')
                download_count += 1
            except OSError as error:
                errors.append(f'{served}: cannot read download: {error}')
            if entry['path'] == 'definition.pdf':
                definition_links.append(href)
    if current:
        require(any(link in current.links for link in definition_links),
                'standards/documentation', 'missing link to an archived definition PDF')
        require('/preview/standards/documentation/versions/' in current.links,
                'standards/documentation', 'missing version history link')
    return errors, len(pages), download_count


if __name__ == '__main__':
    errors, page_count, download_count = check(Path(sys.argv[1]))
    for error in errors:
        print(f'ERROR: {error}', file=sys.stderr)
    print(f'Checked {page_count} pages and {download_count} downloads; {len(errors)} failure(s).')
    sys.exit(bool(errors))
