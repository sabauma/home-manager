{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-beta;

    policies = {
      # Disable private attribution, Mozilla's "privacy preserving"
      # ad/tracking APIs.
      Preferences."dom.private-attribution.submission.enabled" = false;

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
        FeatureRecommendations = false;   # Don’t recommend browser features
        Locked = true;                    # Prevent the user from changing user messaging preferences
        MoreFromMozilla = false;          # Don’t show the “More from Mozilla” section in Preferences
        SkipOnboarding = true;            # Don’t show onboarding messages on the new tab page
        UrlbarInterventions = false;      # Don’t offer suggestions in the URL bar
        WhatsNew = false;                 # Remove the “What’s New” icon and menuitem
      };
    };
  };
}
