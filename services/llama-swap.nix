{ pkgs, ... }:
{
  # CUDA toolkit derivations are unfree; only hosts importing this service
  # need that allowance, so it's scoped here rather than widening
  # profiles/common.nix's narrower allowUnfreePredicate for every host.
  # nixpkgs.config is evaluated per-nixosSystem, so this doesn't leak into
  # hosts that don't import this file.
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.cudaSupport = true;

  # GPU access: this line is WSL-specific (NixOS-WSL has no native NVIDIA
  # driver -- hardware.nvidia doesn't apply under WSL2 -- so CUDA binaries
  # need Windows' own driver stub at /usr/lib/wsl/lib on their library
  # path). A bare-metal host with a real `hardware.nvidia` driver wouldn't
  # need this and should drop/replace it when that host exists.
  environment.sessionVariables.LD_LIBRARY_PATH = [ "/usr/lib/wsl/lib" ];

  environment.systemPackages = [
    (pkgs.llama-cpp.override { cudaSupport = true; })
    pkgs.llama-swap
  ];

  # Per-host model list. Currently just qwen9b (wslToasterRTX, mirroring
  # the flags from the working qwen3.5-9b.bat: text-only, 128K ctx, Q8 KV
  # cache, thinking disabled). ${PORT} is llama-swap's own injected
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
    # WSL-specific -- see the GPU access comment above.
    environment.LD_LIBRARY_PATH = "/usr/lib/wsl/lib";
    serviceConfig = {
      ExecStart = "${pkgs.llama-swap}/bin/llama-swap --config /etc/llama-swap/config.yaml --listen :8080";
      Restart = "on-failure";
    };
  };
}
