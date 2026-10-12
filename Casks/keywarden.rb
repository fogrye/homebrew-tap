cask "keywarden" do
  version "0.1.1,13"
  sha256 "a4c3d5f75005ee93fc7fb2c2ee489e2560f4434fdb2c9aca962e5e7f6246475f"

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
