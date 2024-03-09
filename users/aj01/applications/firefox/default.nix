{pkgs, ...} @ args: let
  /*
    homepage = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Ruixi-rebirth/someSource/main/firefox/homepage.html";
    sha256 = "sha256-UmT5B/dMl5UCM5O+pSFWxOl5HtDV2OqsM1yHSs/ciQ4=";
  };
  */
  homepage = ../../links.html;
  /*
  bg = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Ruixi-rebirth/someSource/main/firefox/bg.png";
    sha256 = "sha256-dpMWCAtYT3ZHLftQQ32BIg800I7SDH6SQ9ET3yiOr90=";
  };
  */
  bg = ../../wall3.png;
  logo = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Ruixi-rebirth/someSource/main/firefox/logo.png";
    sha256 = "sha256-e6L3xq4AXv3V3LV7Os9ZE04R7U8vxdRornBP5x4DWm8=";
  };
in {
  /*
  defaultApplications.browser = {
    cmd = "${pkgs.pkgs.wrapFirefox}/bin/firefox";
    desktop = "firefox";
  };
  */

  home = {
    sessionVariables = {
      BROWSER = "firefox";
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_USE_XINPUT2 = "1";
      MOZ_DBUS_REMOTE = "1";
      MOZ_WEBRENDER = "1";
      MOZ_ACCELERATED = "1";
    };
  };
  programs.firefox = {
    enable = true;

    policies = {
      DisplayBookmarksToolbar = true;
      Preferences = {
        "browser.toolbars.bookmarks.visibility" = "never";
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "media.ffmpeg.vaapi.enabled" = true;
      };
    };
    profiles.default = {
      extensions = with (import ./addons.nix args); [
        ublock-origin
        sidebery
        stylus
        languagetool
      ];
      settings = {
        "browser.startup.homepage" = "file://${homepage}";
        "browser.aboutConfig.showWarning" = false;

        # newtab shenanigans
        "browser.newtabpage.enabled" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.default.sites" = false;

        # disable recommendation pane in about:addons
        "extensions.getAddons.showPane" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "browser.discovery.enabled" = false;

        # disable pocket
        "extensions.pocket.enabled" = false;

        # disable telemetry
        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.server" = "data:,";
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.coverage.opt-out" = true;
        "toolkit.coverage.opt-out" = true;
        "toolkit.coverage.endpoint.base" = "";
        "browser.ping-centre.telemetry" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "toolkit.telemetry.reportingpolicy.firstRun" = false;

        "experiments.activeExperiment" = false;
        "experiments.enabled" = false;
        "experiments.supported" = false;
        "network.allow-experiments" = false;

        # disable studies
        "app.shield.optoutstudies.enabled" = false;
        "app.normandy.enabled" = false;
        "app.normandy.api_url" = "";

        # disable crash reports
        "breakpad.reportURL" = "";
        "browser.tabs.crashReporting.sendReport" = false;
        "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;

        # enable style customizations (TODO: check if this is needed or setting userChrome enables this anyway)
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        # ui looks
        "browser.uiCustomization.state" = ''
          {"placements":{"widget-overflow-fixed-list":["fxa-toolbar-menu-button","sidebar-button"],"unified-extensions-area":["moz-addon_7tv_app-browser-action","ublock0_raymondhill_net-browser-action","_3c078156-979c-498b-8990-85f7987dd929_-browser-action","_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action","enhancerforyoutube_maximerf_addons_mozilla_org-browser-action","languagetool-webextension_languagetool_org-browser-action"],"nav-bar":["back-button","forward-button","stop-reload-button","urlbar-container","save-to-pocket-button","downloads-button","unified-extensions-button"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["firefox-view-button","tabbrowser-tabs","new-tab-button","alltabs-button"],"PersonalToolbar":["import-button","personal-bookmarks"]},"seen":["developer-button","ublock0_raymondhill_net-browser-action","_3c078156-979c-498b-8990-85f7987dd929_-browser-action","_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action","profiler-button","enhancerforyoutube_maximerf_addons_mozilla_org-browser-action","languagetool-webextension_languagetool_org-browser-action","moz-addon_7tv_app-browser-action"],"dirtyAreaCache":["nav-bar","PersonalToolbar","unified-extensions-area","toolbar-menubar","TabsToolbar","widget-overflow-fixed-list"],"currentVersion":19,"newElementCount":5}
        '';
        "extensions.activeThemeID" = "default-theme@mozilla.org";
        "browser.theme.dark-private-windows" = false;
        "browser.toolbars.bookmarks.visibility" = "never";
      };
      userChrome = ''
        /*================== SIDEBAR ==================*/
        /* The default sidebar width. */
        /* #sidebar-box { */
        /*   overflow: hidden!important; */
        /*   position: relative!important; */
        /*   transition: all 300ms!important; */
        /*   min-width: 60px !important; */
        /*   max-width: 60px !important; */
        /* } */

        /* The sidebar width when hovered. */
        /* #sidebar-box #sidebar,#sidebar-box:hover { */
        /*   transition: all 300ms!important; */
        /*   min-width: 60px !important; */
        /*   max-width: 200px !important; */
        /* } */


        /* only remove TST headers */
        /*
        #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"] #sidebar-header {
          display: none; /* remove sidebar header */
          border-color: var(--base_color2) !important;
        }
        */

        /*******************/
        .sidebar-splitter {
          /* display: none;  remove sidebar split line */
          min-width: 1px !important;
          max-width: 1px !important;
          border-color: var(--base_color2) !important;
        }

        /* remove top tabbar */
        /*
        #titlebar { visibility: collapse !important; }
        */

        /*================== URL BAR ==================*/
        /*
        #urlbar .urlbar-input-box {
          text-align: center !important;
        }
        */

        /*
        * {
        font-family: JetBrainsMono Nerd Font Mono !important;
        font-size: 12pt !important;
        }
        */

        /* #nav-bar { visibility: collapse !important; } */

        /* hide horizontal tabs at the top of the window */
        /*
          #TabsToolbar > * {
            visibility: collapse;
          }
        */


        /* hide navigation bar when it is not focused; use Ctrl+L to get focus */
        /*
          #main-window:not([customizing]) #navigator-toolbox:not(:focus-within):not(:hover) {
            margin-top: -45px;
          }
          #navigator-toolbox {
            transition: 0.2s margin-top ease-out;
          }
        */

        /* hide tabs toolbar for sidebery etc. */
        #TabsToolbar {
          display: none;
        }
        #sidebar-header {
          display: none;
        }
      '';
      userContent = ''
                /*hide all scroll bars*/
                /* *{ scrollbar-width: none !important } */

                /*
                * {
                font-family: JetBrainsMono Nerd Font Mono;
                }
                */

                @-moz-document url-prefix("about:") {
                    :root {
                        --in-content-page-background: #1E1E2E !important;
                    }
                }


                @-moz-document url-prefix(about:home), url-prefix(about:newtab){

            /* show nightly logo instead of default firefox logo in newtabpage */
            .search-wrapper .logo-and-wordmark .logo {
                background: url("${logo}") no-repeat center !important;
                background-size: auto !important;
                background-size: 82px !important;
                display: inline-block !important;
                height: 82px !important;
                width: 82px !important;
            }

            body {
                background-color: #000000 !important;
                background: url("${bg}") no-repeat fixed !important;
                background-size: cover !important;
                --newtab-background-color: #000000 !important;
                --newtab-background-color-secondary: #101010 !important;
            }

            body[lwt-newtab-brighttext] {
                --newtab-background-color: #000000 !important;
                --newtab-background-color-secondary: #101010 !important;

            }

            .top-site-outer .top-site-icon {
                background-color: transparent !important;

            }

            .top-site-outer .tile {
                background-color: rgba(49, 49, 49, 0.4) !important;
            }

            .top-sites-list:not(.dnd-active) .top-site-outer:is(.active, :focus, :hover) {
                background: rgba(49, 49, 49, 0.3) !important;
            }

            .top-site-outer .context-menu-button:is(:active, :focus) {
                background-color: transparent !important;
            }

            .search-wrapper .search-handoff-button{
                border-radius: 40px !important;
                background-color: rgba(49, 49, 49, 0.4) !important;
            }
        }
      '';
    };
  };
}
