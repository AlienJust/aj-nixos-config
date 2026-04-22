{
  config,
  pkgs,
  ...
}: {
  # Разрешаем Nginx читать сертификаты
  users.users.nginx.extraGroups = ["acme"];

  services.nginx = {
    enable = true;
    virtualHosts = {
      "alexdeb.ru" = {
        # ВАЖНО: Убираем *.alexdeb.ru из алиасов, если используем webroot.
        # Можно добавить конкретные поддомены, например: "www.alexdeb.ru"
        serverAliases = ["git.alexdeb.ru" "nxoo.alexdeb.ru" "nuget.alexdeb.ru" "oo.alexdeb.ru"];

        # Настройка для отдачи файлов проверки Let's Encrypt
        locations."/.well-known/acme-challenge" = {
          root = "/var/lib/acme/.challenges";
        };

        # Редирект всего остального на HTTPS
        locations."/" = {
          return = "301 https://$host$request_uri";
        };
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "aj001@mail.ru";
      group = "nginx";
    };

    certs = {
      "alexdeb.ru" = {
        webroot = "/var/lib/acme/.challenges";
        # Wildcard (*.) ТУТ БЫТЬ НЕ ДОЛЖНО. Только конкретные имена:
        extraDomainNames = ["git.alexdeb.ru" "nxoo.alexdeb.ru" "nuget.alexdeb.ru" "oo.alexdeb.ru"];
        #dnsProvider = "timewebcloud";
        #credentialsFile = config.sops.secrets."dns/token".path;
        #webroot = null;
      };
    };
  };
}
