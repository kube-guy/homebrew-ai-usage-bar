# homebrew-ai-usage-bar

[ai-usage-bar](https://github.com/kube-guy/ai-usage-bar) 용 Homebrew tap.

Claude Code 와 Codex CLI 의 사용량 한도를 macOS 메뉴바에 표시하는 앱입니다.

```sh
brew tap kube-guy/ai-usage-bar
brew trust --formula kube-guy/ai-usage-bar/ai-usage-bar
brew install ai-usage-bar
brew services start ai-usage-bar
```

Homebrew 7.0 부터는 서드파티 tap 의 formula 를 쓰려면 `brew trust` 가 한 번 필요합니다.
tap 전체를 신뢰하려면 `brew trust kube-guy/ai-usage-bar` 를 쓰면 됩니다.

formula 는 `Formula/ai-usage-bar.rb` 하나뿐이며, 새 릴리스가 나오면
본체 저장소의 `scripts/release.sh` 가 `url` / `sha256` 을 갱신해 커밋합니다.
