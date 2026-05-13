cask "claude-visor" do
  version "2.1.3"
  sha256 "bce7ffe9754b31e70421a8f8ee43af548f633e71a6356f55354b2ae362dfedae"

  url "https://github.com/824zzy/claude-visor/releases/download/v#{version}/ClaudeVisor-v#{version}.zip"
  name "Claude Visor"
  desc "Dynamic Island for Claude Code sessions in the menu bar"
  homepage "https://github.com/824zzy/claude-visor"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :sonoma"

  app "Claude Visor.app"

  # The app is ad-hoc signed (no Apple Developer ID). Without removing the
  # quarantine xattr, macOS Gatekeeper shows a scary "malware" dialog on
  # first launch. This postflight strips it so users can just open the app.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Claude Visor.app"]
    system_command "/usr/bin/codesign",
                   args: ["--force", "--deep", "--sign", "-", "#{appdir}/Claude Visor.app"]
  end

  # The hook file at ~/.claude/hooks/claude-visor-state.py is deliberately
  # excluded from zap. It lives in Claude Code's shared hooks directory
  # alongside other tools' hooks, and removing it would require surgically
  # editing settings.json which is also shared. Users who want to fully
  # remove the hook should delete the file manually and clean up any
  # claude-visor-state.py entries in ~/.claude/settings.json.
  zap trash: [
    "~/Library/Application Support/Claude Visor",
    "~/Library/Caches/com.824zzy.ClaudeVisor",
    "~/Library/HTTPStorages/com.824zzy.ClaudeVisor",
    "~/Library/Logs/ClaudeVisor",
    "~/Library/Preferences/com.824zzy.ClaudeVisor.plist",
  ]
end
