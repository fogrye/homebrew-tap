cask "keywarden" do
  version "0.1.0,10"
  sha256 "d643918cd3939306b20860eac54b7e1a7943316f88d22427893a5bea49cd0c59"

  url "https://github.com/fogrye/Keywarden/releases/download/v#{version.csv.first}/Keywarden-#{version.csv.first}-#{version.csv.second}.zip"
  name "Keywarden"
  desc "Native Bitwarden-compatible vault with Touch ID browser unlock"
  homepage "https://github.com/fogrye/Keywarden"

  livecheck do
    url :url
    regex(/^Keywarden[._-](\d+(?:\.\d+)+)-(\d+)\.zip$/i)
    strategy :github_latest do |json, regex|
      json["assets"].filter_map do |asset|
        match = asset["name"].match(regex)
        "#{match[1]},#{match[2]}" if match
      end
    end
  end

  depends_on arch: :arm64
  depends_on macos: :tahoe

  app "Keywarden.app"

  caveats <<~EOS
    Disconnect browsers in Keywarden Settings > Browsers before uninstalling.
  EOS
end
