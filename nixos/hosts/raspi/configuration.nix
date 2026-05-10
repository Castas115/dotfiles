{ pkgs, ... }:

{
  services.openssh.enable = true;

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      functions -q __orig_fish_prompt; or functions --copy fish_prompt __orig_fish_prompt
      function fish_prompt
          set_color red --bold
          echo -n 'pi '
          set_color normal
          __orig_fish_prompt
      end
    '';
  };
  users.users.jon.shell = pkgs.fish;

  # ISP/router peers poorly with Cloudflare R2 (172.64.0.0/13) where Docker
  # Hub stores blobs. Use Google's pull-through cache to bypass it.
  virtualisation.docker.daemon.settings = {
    registry-mirrors = [ "https://mirror.gcr.io" ];
  };
}
