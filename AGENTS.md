# homebrew-kit

kube-guy 의 macOS 유틸리티용 Homebrew tap.
formula 는 `Formula/ai-usage-bar.rb` 하나뿐이고, 본체 저장소의 `scripts/release.sh` 가
새 릴리스마다 `url` / `sha256` 을 갱신해 커밋한다.

## 커밋 신원 — 전역 git 설정을 쓰지 않는다

이 저장소는 공개 저장소다. 커밋 작성자는 반드시 아래로 고정한다.

```
kube-guy <324278276+kube-guy@users.noreply.github.com>
```

**전역 `~/.gitconfig` 가 이 저장소의 커밋에 쓰이게 두지 않는다.** 거기에는 업무용 신원
(실명 + 회사 이메일)이 들어 있고, 한 번 푸시되면 되돌릴 수 없다.

커밋을 만드는 작업 전에 매번 확인한다.

```sh
git var GIT_AUTHOR_IDENT   # kube-guy <324278276+kube-guy@users.noreply.github.com> 여야 한다
```

- 값이 다르면 커밋하지 말고 `git config user.name` / `user.email` 을 먼저 설정한다.
- **`-c user.email=...` 을 커밋마다 붙이는 방식에 의존하지 않는다.** `git merge`,
  `git rebase`, `git cherry-pick`, `git revert` 는 커밋을 만들면서도 이 지정이 빠지기 쉽다.
- 푸시 전에 `git log --format='%an <%ae>'` 로 **전체** 커밋의 작성자를 확인한다.
- `.git/config` 와 `~/.gitconfig` 의 `[includeIf "gitdir:~/homebrew-kit/"]`
  양쪽에 같은 신원이 걸려 있다.
- 공개될 파일에 실명·회사 이메일·개인 이메일을 적지 않는다.

이 파일이 정본이고 `CLAUDE.md` 는 이 파일을 가리키는 심볼릭 링크다.
