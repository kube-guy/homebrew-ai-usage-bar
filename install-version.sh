#!/usr/bin/env bash
# 이 tap 의 도구를 과거 버전으로 설치한다.
#
#   ./install-version.sh ai-usage-bar 0.7.2
#   ./install-version.sh ai-usage-bar latest     # 최신으로 되돌리기
#
# Homebrew 는 tap 안의 formula 파일 하나만 보고 버전을 정한다. 그래서 그 파일을
# 해당 버전의 커밋으로 잠깐 되돌려 설치한 뒤, 파일은 원래대로 돌려놓는다.
# 파일을 되돌린 채 두면 `brew update` 가 덮어써 다음 업그레이드에서 조용히 최신으로
# 올라가므로, 설치한 버전에 머무르도록 pin 까지 걸어둔다.
set -euo pipefail

formula="${1:-}"
version="${2:-}"
if [[ -z "$formula" || -z "$version" ]]; then
    echo "사용법: $0 <formula> <버전|latest>" >&2
    echo "  예:   $0 ai-usage-bar 0.7.2" >&2
    exit 1
fi

# brew 는 읽을 수 없는 디렉터리에서 실행하면 거부한다. 홈에서 돌린다.
cd "$HOME"

# 이 파일이 놓인 곳이 아니라 brew 가 실제로 읽는 tap 사본을 고쳐야 설치에 반영된다.
# 개발용 원본 저장소에서 이 스크립트를 실행해도 결과가 같도록 경로를 brew 에게 묻는다.
tap="$(brew --repo kube-guy/kit 2>/dev/null || true)"
[[ -d "$tap/.git" ]] || { echo "tap 이 없습니다. 먼저: brew tap kube-guy/kit" >&2; exit 1; }
file="Formula/${formula}.rb"
[[ -f "$tap/$file" ]] || { echo "이 tap 에 없는 formula 입니다: $formula" >&2; exit 1; }
restore() { git -C "$tap" checkout -q HEAD -- "$file" 2>/dev/null || true; }

if [[ "$version" == "latest" ]]; then
    brew unpin "$formula" 2>/dev/null || true
    restore
    brew upgrade "$formula" || brew install "$formula"
else
    # 릴리스마다 "ai-usage-bar 0.7.2" 형식의 커밋이 하나씩 있다. 그 커밋을 찾는다.
    # awk 를 파이프로 물리면 일찍 끝날 때 git 이 SIGPIPE 로 죽어 pipefail 에 걸린다.
    # 로그를 먼저 변수에 담고 그 위에서 고른다.
    log="$(git -C "$tap" log --format='%H %s' -- "$file")"
    sha="$(awk -v f="$formula" -v v="$version" \
        '$2 == f && $3 == v && !found { print $1; found = 1 }' <<<"$log")"
    if [[ -z "$sha" ]]; then
        echo "'$formula $version' 커밋을 찾지 못했습니다. 설치할 수 있는 버전:" >&2
        awk -v f="$formula" '$2 == f && $3 ~ /^[0-9]+\.[0-9]+\.[0-9]+$/ { print "  " $3 }' <<<"$log" >&2
        exit 1
    fi

    brew unpin "$formula" 2>/dev/null || true
    trap restore EXIT
    git -C "$tap" checkout -q "$sha" -- "$file"
    if brew list --formula "$formula" >/dev/null 2>&1; then
        brew reinstall "$formula"
    else
        brew install "$formula"
    fi
    trap - EXIT
    restore
    brew pin "$formula"
fi

# 상주 서비스로 돌고 있었다면 새 바이너리로 갈아탄다.
services="$(brew services list 2>/dev/null || true)"
if awk -v f="$formula" '$1 == f && $2 == "started" { n++ } END { exit n ? 0 : 1 }' <<<"$services"; then
    brew services restart "$formula"
fi

echo
brew list --versions "$formula"
[[ "$version" == "latest" ]] || echo "pin 상태입니다. 최신으로 돌아가려면: $0 $formula latest"
