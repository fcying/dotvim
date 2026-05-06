#!/usr/bin/env python3
import re
import sys


BLOCK_REPLACEMENTS = (
    (re.compile(r'^([ \t]*)pane command='), 'pane'),
    (re.compile(r'^([ \t]*)plugin location="https'), 'plugin location="zjstatus"'),
)
CWD_RE = re.compile(r'^(?P<indent>[ \t]*)cwd "(?P<cwd>[^"]*)"[ \t]*$')
PANE_RE = re.compile(r'^(?P<indent>[ \t]*)pane(?P<rest>(?:[ \t].*)?)$')
PANE_CWD_RE = re.compile(r'([ \t])cwd="([^"]*)"')


def quote(value):
    return '"' + value.replace('\\', '\\\\').replace('"', '\\"') + '"'


def block_delta(line):
    return line.count('{') - line.count('}')


def replace_blocks(lines):
    out = []
    skip_depth = 0

    for line in lines:
        if skip_depth:
            skip_depth += block_delta(line)
            if skip_depth <= 0:
                skip_depth = 0
            continue

        for pattern, replacement in BLOCK_REPLACEMENTS:
            match = pattern.match(line)
            if not match:
                continue
            out.append(f'{match.group(1)}{replacement}\n')
            skip_depth = 1
            break
        else:
            out.append(line)

    return out


def join_cwd(base, cwd):
    if not cwd or cwd.startswith('/'):
        return cwd
    if base == '/':
        return f'/{cwd}'
    return f'{base}/{cwd}'


def update_pane_cwd(line, global_cwd):
    if not global_cwd:
        return line

    match = PANE_RE.match(line)
    if not match:
        return line

    rest = match.group('rest')
    if '{' in rest and rest.strip() != '{':
        return line

    cwd_match = PANE_CWD_RE.search(rest)
    if cwd_match:
        cwd = cwd_match.group(2)
        if cwd.startswith('/'):
            return line
        cwd = quote(join_cwd(global_cwd, cwd))
        rest = PANE_CWD_RE.sub(rf'\1cwd={cwd}', rest, count=1)
        return f'{match.group("indent")}pane{rest}\n'

    return f'{match.group("indent")}pane cwd={quote(global_cwd)}{rest}\n'


def move_cwd_to_panes(lines):
    out = []
    depth = 0
    in_tab = False
    in_new_tab_template = False
    global_cwd = ''

    for line in lines:
        cwd_match = CWD_RE.match(line)
        if depth == 1 and cwd_match:
            global_cwd = cwd_match.group('cwd')
            continue

        if depth == 1 and re.match(r'^[ \t]*tab(?:[ \t{]|$)', line):
            in_tab = True
        if depth == 1 and re.match(r'^[ \t]*new_tab_template(?:[ \t{]|$)', line):
            in_new_tab_template = True

        if in_tab and not in_new_tab_template and depth >= 2:
            line = update_pane_cwd(line, global_cwd)

        out.append(line)
        depth += block_delta(line)
        if in_tab and depth == 1:
            in_tab = False
        if in_new_tab_template and depth == 1:
            in_new_tab_template = False

    return out


def main():
    lines = sys.stdin.readlines()
    lines = replace_blocks(lines)
    lines = move_cwd_to_panes(lines)
    sys.stdout.writelines(lines)


if __name__ == '__main__':
    main()
