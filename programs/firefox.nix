{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-beta;

    policies = {
      # Disable private attribution, Mozilla's "privacy preserving"
      # ad/tracking APIs.
      Preferences = {
        "browser.newtabpage.activity-stream.showWeather" = false;
        "browser.newtabpage.activity-stream.system.showWeather" = false;

        "dom.private-attribution.submission.enabled" = false;
        "privacy.annotate_channels.strict_list.enabled" = true;
        "privacy.donottrackheader.enabled" = true;
        "privacy.fingerprintingProtection" = true;
        "privacy.globalprivacycontrol.enabled" = true;
        "privacy.globalprivacycontrol.was-ever-enabled" = true;
        "privacy.partition.network_state.ocsp_cache" = true;
        "privacy.popups.showBrowserMessage" = false;
        "privacy.query_stripping.enabled" = true;
        "privacy.query_stripping.enabled.pbmode" = true;
        "privacy.resistFingerprinting" = true;
        "privacy.trackingprotection.emailtracking.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.userContext.enabled" = true;

        "toolkit.coverage.endpoint.base" = "";
        "toolkit.coverage.opt-out" = true;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.coverage.opt-out" = true;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.pioneer-new-studies-available" = false;
        "toolkit.telemetry.reportingpolicy.firstRun" = false;
        "toolkit.telemetry.server" = "data:";
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        "trailhead.firstrun.didSeeAboutWelcome" = true;
      };

      PopupBlocking.Default = true;

      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      PasswordManagerEnabled = false;
      SearchBar = "unified";
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };

      UserMessaging = {
        ExtensionRecommendations = false; # Don’t recommend extensions while the user is visiting web pages
        FeatureRecommendations = false; # Don’t recommend browser features
        Locked = true; # Prevent the user from changing user messaging preferences
        MoreFromMozilla = false; # Don’t show the "More from Mozilla" section in Preferences
        SkipOnboarding = true; # Don’t show onboarding messages on the new tab page
        UrlbarInterventions = false; # Don’t offer suggestions in the URL bar
        WhatsNew = false; # Remove the “What’s New” icon and menuitem
      };
    };
  };
}
