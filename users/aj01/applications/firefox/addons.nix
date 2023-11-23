{
  pkgs,
  lib,
  ...
}: let
  # stolen from https://github.com/nix-community/nur-combined/blob/master/repos/rycee/pkgs/firefox-addons/default.nix
  buildFirefoxXpiAddon = lib.makeOverridable ({
    stdenv ? pkgs.stdenv,
    fetchurl ? pkgs.fetchurl,
    pname,
    version,
    addonId,
    url,
    sha256,
    meta ? {},
    ...
  }:
    stdenv.mkDerivation {
      name = "${pname}-${version}";

      inherit meta;

      src = fetchurl {inherit url sha256;};

      preferLocalBuild = true;
      allowSubstitutes = true;

      buildCommand = ''
        dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
        mkdir -p "$dst"
        install -v -m644 "$src" "$dst/${addonId}.xpi"
      '';
    });
in {
  "sidebery" = buildFirefoxXpiAddon {
    pname = "sidebery";
    version = "5.0.0";
    addonId = "{3c078156-979c-498b-8990-85f7987dd929}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4170134/sidebery-5.0.0.xpi";
    sha256 = "f592427a1c68d3e51aee208d05588f39702496957771fd84b76a93e364138bf5";
    meta = with lib; {
      homepage = "https://github.com/mbnuqw/sidebery";
      description = "Tabs tree and bookmarks in sidebar with advanced containers configuration.";
      license = licenses.mit;
      mozPermissions = [
        "activeTab"
        "tabs"
        "contextualIdentities"
        "cookies"
        "storage"
        "unlimitedStorage"
        "sessions"
        "menus"
        "menus.overrideContext"
        "search"
        "theme"
      ];
      platforms = platforms.all;
    };
  };

  "ublock-origin" = buildFirefoxXpiAddon {
    pname = "ublock-origin";
    version = "1.52.2";
    addonId = "uBlock0@raymondhill.net";
    url = "https://addons.mozilla.org/firefox/downloads/file/4171020/ublock_origin-1.52.2.xpi";
    sha256 = "e8ee3f9d597a6d42db9d73fe87c1d521de340755fd8bfdd69e41623edfe096d6";
    meta = with lib; {
      homepage = "https://github.com/gorhill/uBlock#ublock-origin";
      description = "Finally, an efficient wide-spectrum content blocker. Easy on CPU and memory.";
      license = licenses.gpl3;
      mozPermissions = [
        "dns"
        "menus"
        "privacy"
        "storage"
        "tabs"
        "unlimitedStorage"
        "webNavigation"
        "webRequest"
        "webRequestBlocking"
        "<all_urls>"
        "http://*/*"
        "https://*/*"
        "file://*/*"
        "https://easylist.to/*"
        "https://*.fanboy.co.nz/*"
        "https://filterlists.com/*"
        "https://forums.lanik.us/*"
        "https://github.com/*"
        "https://*.github.io/*"
        "https://*.letsblock.it/*"
      ];
      platforms = platforms.all;
    };
  };
  "stylus" = buildFirefoxXpiAddon {
    pname = "stylus";
    version = "1.5.35";
    addonId = "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4160414/styl_us-1.5.35.xpi";
    sha256 = "d415ee11fa4a4313096a268e54fd80fa93143345be16f417eb1300a6ebe26ba1";
    meta = with lib; {
      homepage = "https://add0n.com/stylus.html";
      description = "Redesign your favorite websites with Stylus, an actively developed and community driven userstyles manager. Easily install custom themes from popular online repositories, or create, edit, and manage your own personalized CSS stylesheets.";
      license = licenses.gpl3;
      mozPermissions = [
        "tabs"
        "webNavigation"
        "webRequest"
        "webRequestBlocking"
        "contextMenus"
        "storage"
        "unlimitedStorage"
        "alarms"
        "<all_urls>"
        "http://userstyles.org/*"
        "https://userstyles.org/*"
      ];
      platforms = platforms.all;
    };
  };
  "languagetool" = buildFirefoxXpiAddon {
    pname = "languagetool";
    version = "7.1.13";
    addonId = "languagetool-webextension@languagetool.org";
    url = "https://addons.mozilla.org/firefox/downloads/file/4128570/languagetool-7.1.13.xpi";
    sha256 = "e9002ae915c74ff2fe2f986e86a50b0b1617bcd852443e3d5b8e733e476c5808";
    meta = with lib; {
      homepage = "https://languagetool.org";
      description = "With this extension you can check text with the free style and grammar checker LanguageTool. It finds many errors that a simple spell checker cannot detect, like mixing up there/their, a/an, or repeating a word.";
      license = {
        shortName = "languagetool";
        fullName = "Custom License for LanguageTool";
        url = "https://languagetool.org/legal/";
        free = false;
      };
      mozPermissions = [
        "activeTab"
        "storage"
        "contextMenus"
        "alarms"
        "http://*/*"
        "https://*/*"
        "file:///*"
        "*://docs.google.com/document/*"
        "*://languagetool.org/*"
      ];
      platforms = platforms.all;
    };
  };
}
