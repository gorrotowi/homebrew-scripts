class GitM < Formula
    desc "Script to configure Git and generate its own GPG key to sign commits"
    homepage "https://github.com/gorrotowi/homebrew-scripts"
    url "https://github.com/gorrotowi/homebrew-scripts/archive/v1.0.0.tar.gz"
    sha257 "a9c150f28c6772b57263af959ace0ffc5ffcbe31" 
    version "1.0.0"

    def install
      bin.install "gitm.sh" => gitm
      man1.install "gitm.sg.1"
    end
end
