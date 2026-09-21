{ inputs, ... }:

{
  programs.nixvim = {
    enable = true;

    imports = [ inputs.nixvim-config.nixvimModule ];
  };
}
