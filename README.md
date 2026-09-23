# homebrew-kit

kube-guy 의 macOS 유틸리티용 Homebrew tap.

```sh
brew tap kube-guy/kit
```

Homebrew 7.0 부터는 서드파티 tap 의 formula 를 쓰려면 `brew trust` 가 한 번 필요합니다.
tap 전체를 신뢰하려면 `brew trust kube-guy/kit`, formula 하나만 신뢰하려면 아래처럼 합니다.

## 담긴 도구

### [ai-usage-bar](https://github.com/kube-guy/ai-usage-bar)

Claude Code 와 Codex CLI 의 사용량 한도를 macOS 메뉴바에 표시합니다.

```sh
brew trust --formula kube-guy/kit/ai-usage-bar
brew install ai-usage-bar
brew services start ai-usage-bar
```

### [otp](https://github.com/kube-guy/otp-cli)

TOTP(RFC 6238) 코드를 생성합니다. 시크릿은 macOS Keychain 에 저장하고,
단축키를 누르면 커서 위치에 코드를 바로 입력합니다.

```sh
brew trust --formula kube-guy/kit/otp
brew install otp
```

## 이전 버전 설치

Homebrew 는 formula 파일 하나만 보고 버전을 정하므로, 기본으로는 최신만 설치됩니다.
`install-version.sh` 가 그 파일을 원하는 버전의 커밋으로 잠깐 되돌려 설치하고 원래대로
돌려놓습니다. 설치한 버전에 머무르도록 `brew pin` 까지 걸어줍니다.

```sh
"$(brew --repo kube-guy/kit)"/install-version.sh ai-usage-bar 0.7.2
"$(brew --repo kube-guy/kit)"/install-version.sh ai-usage-bar latest   # 되돌리기
```

버전을 빼고 실행하면 설치할 수 있는 버전이 나옵니다. ai-usage-bar 는 버전마다 메뉴바
모습이 달라서, [릴리스별 모습](https://github.com/kube-guy/ai-usage-bar/blob/main/docs/releases/README.md)
에서 보고 고를 수 있습니다.

## 구조

formula 는 `Formula/` 에 있고, 각 도구의 소스는 별도 저장소에 있습니다.
새 릴리스가 나오면 해당 저장소의 `scripts/release.sh` 가 `url` / `sha256` 을 갱신해 커밋합니다.

```
Formula/
├── ai-usage-bar.rb
└── otp.rb
install-version.sh   # 이전 버전 설치
```
