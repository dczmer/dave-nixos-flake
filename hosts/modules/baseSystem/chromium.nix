# NOTE: this is done in configuration.nix instead of home-manager, because
# home-manager doesn't have the extraOpts settings :(
{
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.baseSystem.chromium = {
    enable = mkEnableOption "Chromium";
  };

  config = {
    environment.systemPackages = with pkgs; [
      chromium
    ];

    programs.browserpass = {
      enable = true;
    };

    programs.chromium = {
      enable = true;
      extensions = [
        # browserpass
        "naepdomgkenhinolocfifgehidddafch"
        # privacy-badger
        "pkehgijcmpdhfbdbbnkijodmdjhbjlgp"
        # darkreader
        "eimadpbcbfnmbkopoojfekhnkhdbieeh"
        # xbrowsersync
        "lcbjdhceifofjlpecfpeimnnphbcjgnc"
        # react dev tools
        "fmkadmapgofadopljbjfkapdkoienihi"
      ];
      homepageLocation = "https://nixos.org";
      extraOpts = {
        "BrowserSignin" = 0;
        "SyncDisabled" = true;
        "PasswordManagerEnabled" = false;
        "BuiltInDnsClientEnabled" = false;
        "MetricsReportingEnabled" = true;
        "SpellcheckEnabled" = true;
        "SpellcheckLanguage" = [ "en-US" ];
        "HomepageIsNewTabPage" = true;
        "HomepageLocation" = "https://nixos.org";
        "DnsOverHttpsMode" = "automatic";
        "BookmarkBarEnabled" = true;
        "HardwareAccelerationModeEnabled" = true;
        "HttpsOnlyMode" = "force_enabled";
        "SafeBrowsingProtectionLevel" = 2; # enhanced = 2 or "EnhancedProtection"
        "SafeBrowsingAllowlistDomains" = [ ];
        "SafeBrowsingSurveysEnabled" = false;
        "DefaultDownloadDirectory" = "~/Downloads";
        "PromptForDownloadLocation" = true;
        "DefaultSearchProviderEnabled" = true;
        "DefaultSearchProviderName" = "DuckDuckGo";
        "DefaultSearchProviderKeyword" = "duckduckgo.com";
        "DefaultSearchProviderSearchURL" = "https://duckduckgo.com/?q={searchTerms}";

        # TODO: font size?
      };
    };
  };
}
