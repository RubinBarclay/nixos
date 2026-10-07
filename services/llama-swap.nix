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

  # Per-host model list (wslToasterRTX). ${PORT} is llama-swap's own
  # injected placeholder, not a Nix interpolation -- escaped below as
  # ''${PORT}. Thinking is controlled via --reasoning on/off, not
  # --chat-template-kwargs '{"enable_thinking":...}' -- this build's
  # llama-server flags that kwarg as deprecated and (per its own startup
  # log, discovered on qwen9b) was still resolving the chat template with
  # thinking = 1 regardless of what the kwarg said.
  #
  # qwen4b is split into two llama-swap entries pointing at the same GGUF
  # (-nothink / -think) because llama-swap's reasoning mode is a process
  # launch flag, not a per-request option -- Hermes slots that need
  # different thinking behavior from the same model have to pick between
  # the two entries instead.
  #
  # qwen2b is Qwen3.5's native vision-language variant; it's the only
  # entry that loads an --mmproj (Qwen3.5 ships a vision encoder at every
  # size, but qwen4b/qwen08b's Hermes slots are text-only, so their mmproj
  # is never downloaded/wired up).
  environment.etc."llama-swap/config.yaml".text =
    let
      llamaCppCuda = pkgs.llama-cpp.override { cudaSupport = true; };
      modelDir = "/home/rustikk/models/qwen3.5-9b";
    in ''
      models:
        "qwen9b":
          cmd: |
            ${llamaCppCuda}/bin/llama-server -m "${modelDir}/Qwen3.5-9B-Q4_K_M.gguf" --jinja -ngl 99 -fa on -c 65536 -ctk q8_0 -ctv q8_0 -np 1 --reasoning off --port ''${PORT}
          ttl: 300

        "qwen4b-nothink":
          cmd: |
            ${llamaCppCuda}/bin/llama-server -m "${modelDir}/Qwen3.5-4B-Q4_K_M.gguf" --jinja -ngl 99 -fa on -c 65536 -ctk q8_0 -ctv q8_0 -np 1 --reasoning off --port ''${PORT}
          ttl: 300

        "qwen4b-think":
          cmd: |
            ${llamaCppCuda}/bin/llama-server -m "${modelDir}/Qwen3.5-4B-Q4_K_M.gguf" --jinja -ngl 99 -fa on -c 65536 -ctk q8_0 -ctv q8_0 -np 1 --reasoning on --reasoning-budget 4096 --port ''${PORT}
          ttl: 300

        "qwen2b":
          cmd: |
            ${llamaCppCuda}/bin/llama-server -m "${modelDir}/Qwen3.5-2B-Q4_K_M.gguf" --mmproj "${modelDir}/Qwen3.5-2B-mmproj-F16.gguf" --jinja -ngl 99 -fa on -c 16384 -ctk q8_0 -ctv q8_0 -np 1 --reasoning off --port ''${PORT}
          ttl: 300

        "qwen08b":
          cmd: |
            ${llamaCppCuda}/bin/llama-server -m "${modelDir}/Qwen3.5-0.8B-Q4_K_M.gguf" --jinja -ngl 99 -fa on -c 8192 -ctk q8_0 -ctv q8_0 -np 1 --reasoning off --port ''${PORT}
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
