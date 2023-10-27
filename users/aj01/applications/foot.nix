{lib, ...}: {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = lib.mkForce "IosevkaTerm NFM Light:size=12";
        font-bold = lib.mkForce "IosevkaTerm NFM:size=12";
      };
      mouse = {
        hide-when-typing = false;
      };
      colors = {
        foreground = "ffffff";
        background = "232136";
        regular0 = "000000";
        regular1 = "ff0000";
        regular2 = "37dd21";
        regular3 = "fee409";
        regular4 = "1460d2";
        regular5 = "ff005d";
        regular6 = "00bbbb";
        regular7 = "bbbbbb";
        bright0 = "545454";
        bright1 = "f40d17";
        bright2 = "3bcf1d";
        bright3 = "ecc809";
        bright4 = "5555ff";
        bright5 = "ff55ff";
        bright6 = "6ae3f9";
        bright7 = "ffffff";
        alpha = 0.85;
      };
      cursor = {
        color = "122637 f0cb09";
      };
    };
  };
}
