{pkgs, ...}:{
	fonts.fontconfig = {
		enable = true;
              };
              services.mpd = {
                enable = true;
                package = pkgs.mpd;
                dataDir = "/home/wyatt/.config/mpd";
                musicDirectory = "/home/wyatt/Music";
                extraConfig = ''
                audio_output {
                  type "pulse"
                  name "fakepipe"
                }
                audio_output {
                  type    "fifo"
                  name    "my_fifo"
                  path    "/tmp/mpd.fifo"
                  format  "44100:16:2"
}
                '';
              };
	gtk = {
		enable = true;
		font.name = "JetBrains Mono";
		font.size = 14;
		theme.package = pkgs.dracula-theme;
		theme.name = "Dracula";
	};
        imports = [
          ./nvim/neovim.nix
          ./waybar.nix
          ./kanshi.nix
          ./ncmpcpp.nix
          ./mako.nix
          ./starship.nix
        ];
	programs.foot = {
		enable = true;
		settings = {
			main = {
				term = "xterm-256color";
				font = "JetBrains Mono:size=14";
				dpi-aware = "yes";
			};
			mouse = {
				hide-when-typing = "yes";
			};
		};
	};
}
