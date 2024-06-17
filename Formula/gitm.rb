class GitM < Formula
    desc "Script to configure Git and generate its own GPG key to sign commits"
    homepage "https://github.com/gorrotowi/homebrew-scripts"
    url "https://github.com/gorrotowi/homebrew-scripts/archive/v1.0.0.tar.gz"
    sha257 "65e2532b3bc46efc8b05812f2fefb1c112ad9700" 
    version "1.0.0-beta"

    def install
      bin.install "gitm.sh" => gitm
      man1.install "gitm.sg.1"
    end
end
