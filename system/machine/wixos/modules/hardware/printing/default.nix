{pkgs, ...}: {
  # Включить CUPS и драйверы HP
  services.printing = {
    enable = true;
    drivers = [pkgs.hplipWithPlugin];
  };

  # Автоматически добавить принтер
  hardware.printers = {
    ensurePrinters = [
      {
        name = "hp1606dn"; # Произвольное имя принтера
        description = "HP LaserJet P1606dn";
        deviceUri = "socket://192.168.11.20:9100"; # Или `ipp://<IP_принтера>`
        # deviceUri = "hp:/net/HP_LaserJet_Professional_P1606dn?ip=192.168.1.50";
        # model = "drv:///hpcups.drv/hp-laserjet_p1606dn.ppd"; # Драйвер
        # model = "drv:///hp/hpcups.drv/hp-laserjet_pro_p1606dn.ppd";
        # model = "${pkgs.hplipWithPlugin}/share/ppd/HP/hp-laserjet_p1606dn.ppd";
        model = "HP/hp-laserjet_professional_p1606dn.ppd.gz";
        location = "Office";
        ppdOptions = {
          PageSize = "A4"; # Доп. настройки (опционально)
          Duplex = "DuplexNoTumble"; # Включить двустороннюю печать
        };
      }
    ];
  };
}
