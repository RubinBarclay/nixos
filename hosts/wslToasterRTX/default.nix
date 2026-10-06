####################################################################
# Template for a NixOS-WSL host — NOT wired to a real machine yet.
#
# To turn this into a real WSL2 distro:
#   1. Copy this directory to hosts/<machine-name>/ (or keep this name).
#   2. Rename the "wsl-template" attribute in flake.nix's
#      nixosConfigurations to match.
#   3. Follow NixOS-WSL's own docs (github:nix-community/NixOS-WSL) to
#      build and import this flake's output as your WSL distro.
#
# Untested from this sandbox — no `nix` binary here and no WSL2 to build
# against. Double-check against NixOS-WSL's current README before relying
# on it.
####################################################################
{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
    ../../profiles/common.nix
  ];

  wsl = {
    enable = true;
    defaultUser = "rustikk";
  };

  networking.hostName = "wslToasterRTX";

  # llama-swap + llama-cpp (CUDA), for the RTX GPU passed through from
  # Windows. CUDA toolkit derivations are unfree; this is the only host
  # with a GPU, so the blanket allowance is scoped here rather than
  # widening profiles/common.nix's narrower allowUnfreePredicate for every
  # host. nixpkgs.config is evaluated per-nixosSystem, so this doesn't leak
  # into thinkToasterT430 or server-template.
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.cudaSupport = true;

  # NixOS-WSL has no native NVIDIA driver -- hardware.nvidia doesn't apply
  # under WSL2. GPU access comes through Windows' own driver via the WSL
  # passthrough stub at /usr/lib/wsl/lib (libcuda.so.1 etc, confirmed
  # present there). CUDA binaries built by nixpkgs need this on their
  # library path to find it instead of the (absent) native driver.
  environment.sessionVariables.LD_LIBRARY_PATH = [ "/usr/lib/wsl/lib" ];

  environment.systemPackages = [
    (pkgs.llama-cpp.override { cudaSupport = true; })
    pkgs.llama-swap
  ];

  # Mirrors the flags from the working qwen3.5-9b.bat (text-only, 128K ctx,
  # Q8 KV cache, thinking disabled). ${PORT} is llama-swap's own injected
  # placeholder, not a Nix interpolation -- escaped below as ''${PORT}.
  environment.etc."llama-swap/config.yaml".text =
    let
      llamaCppCuda = pkgs.llama-cpp.override { cudaSupport = true; };
    in ''
      models:
        "qwen9b":
          cmd: |
            ${llamaCppCuda}/bin/llama-server -m "/home/rustikk/models/qwen3.5-9b/Qwen3.5-9B-Q4_K_M.gguf" --jinja -ngl 99 -fa on -c 131072 -ctk q8_0 -ctv q8_0 -np 1 --chat-template-kwargs '{"enable_thinking":false}' --port ''${PORT}
          ttl: 300
    '';

  systemd.services.llama-swap = {
    wantedBy = [ "multi-user.target" ];
    environment.LD_LIBRARY_PATH = "/usr/lib/wsl/lib";
    serviceConfig = {
      ExecStart = "${pkgs.llama-swap}/bin/llama-swap --config /etc/llama-swap/config.yaml --listen :8080";
      Restart = "on-failure";
    };
  };
}
