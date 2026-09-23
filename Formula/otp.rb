class Otp < Formula
  desc "TOTP code generator that keeps secrets in the macOS Keychain"
  homepage "https://github.com/kube-guy/otp-cli"
  url "https://github.com/kube-guy/otp-cli/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "e7de0ab7aa051459ca30ae997130f2c9960f2d1367d7efb97667a2463a044e55"
  license "MIT"
  head "https://github.com/kube-guy/otp-cli.git", branch: "main"

  depends_on :macos

  def install
    # SwiftPM 자체 샌드박스는 Homebrew 의 빌드 샌드박스와 충돌하므로 끈다.
    system "swift", "build", "--disable-sandbox", "-c", "release",
           "--scratch-path", buildpath/".build"
    bin.install buildpath/".build/release/otp"
  end

  service do
    run [opt_bin/"otp", "agent"]
    keep_alive true
    log_path var/"log/otp.log"
    error_log_path var/"log/otp.err.log"
  end

  def caveats
    <<~EOS
      시크릿 등록:
        otp add <이름>

      TOTP 시크릿은 비밀번호와 동등한 등급입니다. macOS Keychain 의
      login keychain 에 service "otp-cli" 로 저장되며, 처음 읽을 때
      키체인 접근 승인을 한 번 요청할 수 있습니다.

      단축키(기본 ⌘⌥O)로 커서 위치에 코드를 바로 입력하려면:
        otp default <이름>
        brew services start otp

      처음 실행하면 손쉬운 사용 권한을 요청합니다. 시스템 설정 →
      개인정보 보호 및 보안 → 손쉬운 사용 에서 otp 를 허용하세요.
      brew upgrade 로 경로가 바뀌면 다시 허용해야 할 수 있습니다.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/otp --version")
    # RFC 6238 Appendix B 테스트 벡터로 코드 생성이 맞는지 검증한다
    assert_match "통과", shell_output("#{bin}/otp selftest")
  end
end
