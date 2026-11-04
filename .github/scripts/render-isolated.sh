#!/bin/sh
set -eu

# Logs live outside the disposable workspace so failures remain inspectable.
check_name=render
if [ "${CHECK_SITE:-0}" = 1 ]; then check_name=site; fi
if [ "${CHECK_HTML:-0}" = 1 ]; then check_name=html; fi
if [ "${CHECK_HTML:-0}" = external ]; then check_name=external; fi
report_dir="/src/tmp/checks/$check_name"
mkdir -p "$report_dir"
# Clear only this check's previous report, not other checks or live build output.
rm -rf "$report_dir/rendered"
rm -f "$report_dir/"*.log "$report_dir/exit-status.txt"
workspace=$(mktemp -d)
export OUTPUT_DIR="$workspace/public"
cleanup() {
    result=$?
    trap - EXIT
    printf '%s\n' "$result" > "$report_dir/exit-status.txt"
    if [ "$result" -ne 0 ] && [ -d "$OUTPUT_DIR" ]; then
        cp -a "$OUTPUT_DIR" "$report_dir/rendered"
    fi
    rm -rf "$workspace"
    exit "$result"
}
trap cleanup EXIT
run_logged() {
    log=$1
    shift
    result=0
    "$@" > "$report_dir/$log" 2>&1 || result=$?
    cat "$report_dir/$log"
    return "$result"
}

# Keep host dependencies, caches, reports and server locks out of the build.
mkdir "$workspace/src"
tar --exclude='./.buildx-cache*' --exclude=./node_modules --exclude=./.hugo_cache --exclude=./tmp \
    --exclude=./public --exclude=./resources --exclude=./.hugo_build.lock \
    -cf "$workspace/source.tar" .
tar -xf "$workspace/source.tar" -C "$workspace/src"
cd "$workspace/src"
git config --global --add safe.directory "$workspace/src"
export HUGO_CACHEDIR=/src/.hugo_cache
run_logged build.log sh .github/scripts/build-site.sh
if [ "${CHECK_SITE:-0}" = 1 ]; then
    run_logged site.log python3 .github/scripts/check_site.py "$OUTPUT_DIR"
fi
if [ "${CHECK_HTML:-0}" != 0 ]; then
    config=.htmltest.yml
    if [ "$CHECK_HTML" = external ]; then config=.htmltest-external.yml; fi
    # Use the checked-in policy with this disposable render and persistent reports.
    sed -e "s|^DirectoryPath:.*|DirectoryPath: \"$OUTPUT_DIR\"|" \
        -e '/^OutputDir:/d' "$config" > "$workspace/htmltest.yml"
    printf 'OutputDir: "%s"\n' "$report_dir" >> "$workspace/htmltest.yml"
    run_logged console.log htmltest -c "$workspace/htmltest.yml"
fi
