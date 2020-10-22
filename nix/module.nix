{ envname }:
{ lib, pkgs, config, ... }:
with lib;

let
  cfg = config.services.template."${envname}";
  concatAttrs = attrList: fold (x: y: x // y) {} attrList;
in
{
  options.services.template."${envname}" =
    {
      enable = mkEnableOption "Template Service";
      log-level =
        mkOption {
          type = types.str;
          example = "Debug";
          default = "Warn";
          description = "The log level to use";
        };
      hosts =
        mkOption {
          type = types.listOf (types.str);
          example = "templates.cs-syd.eu";
          description = "The host to serve web requests on";
        };
      port =
        mkOption {
          type = types.int;
          example = 8000;
          description = "The port to serve web requests on";
        };
      google-analytics-tracking =
        mkOption {
          type = types.nullOr types.str;
          example = "XX-XXXXXXXX-XX";
          default = null;
          description = "The Google analytics tracking code";
        };
      google-search-console-verification =
        mkOption {
          type = types.nullOr types.str;
          example = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
          default = null;
          description = "The Google search console verification code";
        };
      stripe-secret-key =
        mkOption {
          type = types.str;
          example = "sk_test_XXXXXXXXXXXXXXXXXXXXXXXX";
          default = null;
          description = "The Stripe secret key";
        };
      stripe-publishable-key =
        mkOption {
          type = types.str;
          example = "pk_test_XXXXXXXXXXXXXXXXXXXXXXXX";
          default = null;
          description = "The Stripe publishable key";
        };
    };
  config =
    let
      templatePkgs = (import ./pkgs.nix).templatePackages;
      working-dir = "/www/template/${envname}/";
      # The web server
      web-server-working-dir = working-dir + "web-server/";
      web-server-data-dir = web-server-working-dir + "web-server/";
      web-server-service =
        with cfg;
        optionalAttrs enable {
          "template-${envname}" = {
            description = "Template web server ${envname} Service";
            wantedBy = [ "multi-user.target" ];
            environment =
              {
                "TEMPLATE_WEB_SERVER_LOG_LEVEL" = "${log-level}";
                "TEMPLATE_WEB_SERVER_PORT" = "${builtins.toString port}";
                "TEMPLATE_WEB_SERVER_STRIPE_SECRET_KEY" = "${stripe-secret-key}";
                "TEMPLATE_WEB_SERVER_STRIPE_PUBLISHABLE_KEY" = "${stripe-publishable-key}";
              } // optionalAttrs (!builtins.isNull google-analytics-tracking) {
                "TEMPLATE_WEB_SERVER_GOOGLE_ANALYTICS_TRACKING" = "${google-analytics-tracking}";
              } // optionalAttrs (!builtins.isNull google-search-console-verification) {
                "TEMPLATE_WEB_SERVER_GOOGLE_SEARCH_CONSOLE_VERIFICATION" = "${google-search-console-verification}";
              };
            script =
              ''
                mkdir -p "${web-server-working-dir}"
                cd "${web-server-working-dir}" # We use this instead of 'WorkingDirectory' in the serviceConfig because systemd will not make the workingdir if it's not there.
                ${templatePkgs.template-web-server}/bin/template-web-server \
                  serve
              '';
            serviceConfig =
              {
                Restart = "always";
                RestartSec = 1;
                Nice = 15;
              };
            unitConfig =
              {
                StartLimitIntervalSec = 0;
                # ensure Restart=always is always honoured
              };
          };
        };
      web-server-host =
        with cfg;

        optionalAttrs enable {
          "${head hosts}" =
            {
              enableACME = true;
              forceSSL = true;
              locations."/".proxyPass = "http://localhost:${builtins.toString port}";
              serverAliases = tail hosts;
            };
        };
    in
      mkIf cfg.enable {
        systemd.services = web-server-service;
        networking.firewall.allowedTCPPorts = (optional cfg.enable cfg.port);
        services.nginx.virtualHosts = web-server-host;
      };
}
