{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  programs.chromium = {
    # Seen on stylix and nixpkgs:
    # This enables policies without installing the browser. Policies take up a
    # negligible amount of space, so it's reasonable to have this always on.
    # https://chromeenterprise.google/policies/
    enable = true;
    #defaultSearchProviderEnabled = true;
    #defaultSearchProviderSearchURL = "https://duckduckgo.com/?q={searchTerms}";
    extraOpts = {
      "AutofillAddressEnabled" = false;
      "AutofillCreditCardEnabled" = false;
      "BackgroundModeEnabled" = false;
      "BlockExternalExtensions" = true;
      "BookmarkBarEnabled" = false;
      "BrowserAddPersonEnabled" = false;
      "BrowserGuestModeEnforced" = false;
      "BrowserLabsEnabled" = false;
      "BrowserSignin" = 0;
      #"DefaultSearchProviderName" = "DuckDuckGo";
      "DefaultSearchProviderName" = "Google";
      # "DnsOverHttpsMode" = "secure";
      "EditBookmarksEnabled" = false;
      "EnableMediaRouter" = false;
      "ForceEphemeralProfiles" = false;
      "HideWebStoreIcon" = true;
      "HomepageIsNewTabPage" = true;
      "IncognitoModeAvailability" = 2;
      "OsColorMode" = "dark";
      "PasswordManagerEnabled" = false;
      "PromptForDownloadLocation" = false;
      "RestoreOnStartup" = 5;
      "ShowAppsShortcutInBookmarkBar" = false;
      "ShowHomeButton" = false;
      "SpellcheckEnabled" = false;
      "SpellcheckLanguage" = ["en-US"];
      "SpellCheckServiceEnabled" = false;
      "ShowCastIconInToolbar" = false;
      "SyncDisabled" = true;
      "SystemFeaturesDisableMode" = "hidden";
      "SystemFeaturesDisableList" = ["camera"];
    };
  };
}
