# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Gitm < Formula
  desc "Script to configure Git and generate a GPG key"
  homepage "https://github.com/gorrotowi/homebrew-scripts"
  url "https://github.com/gorrotowi/homebrew-scripts/archive/refs/tags/v1.0.0-alpha.tar.gz"
  sha256 "b506d7a4371e5eaeb84da0860cb649e622b3fd24926de871fa52a34ed5c9719a"

  def install
    bin.install "gitm.sh" => "gitm"
    man1.install "gitm.1"
  end
end
