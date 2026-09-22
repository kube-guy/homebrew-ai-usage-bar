class AiUsageBar < Formula
  desc "Menu bar app showing Claude Code and Codex CLI usage limits"
  homepage "https://github.com/kube-guy/ai-usage-bar"
  url "https://github.com/kube-guy/ai-usage-bar/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "9c952aaeb4f2074fa3df5943719a5e59dcb402f489c8b6f7f20ab11653271356"
  license "MIT"
  head "https://github.com/kube-guy/ai-usage-bar.git", branch: "main"

  depends_on :macos

  def install
    # SwiftPM 자체 샌드박스는 Homebrew 의 빌드 샌드박스와 충돌하므로 끈다.
    system "swift", "build", "--disable-sandbox", "-c", "release",
           "--scratch-path", buildpath/".build"
    bin.install buildpath/".build/release/AIUsageBar" => "ai-usage-bar"
  end

  service do
    run [opt_bin/"ai-usage-bar"]
    keep_alive true
    log_path var/"log/ai-usage-bar.log"
    error_log_path var/"log/ai-usage-bar.err.log"
  end

  def caveats
    <<~EOS
      로그인 상태에서만 사용량을 읽을 수 있습니다:
        Claude Code — 터미널에서 `claude` 실행 후 로그인 (토큰은 macOS Keychain)
        Codex CLI   — 터미널에서 `codex` 실행 후 ChatGPT 계정 로그인

      로그인 후 메뉴바에 띄우려면:
        brew services start ai-usage-bar

      메뉴바 없이 터미널에서 값만 확인하려면:
        ai-usage-bar --dump
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ai-usage-bar --version")
    assert_match "--only", shell_output("#{bin}/ai-usage-bar --help")
  end
end
