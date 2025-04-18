{ pkgs, ... }:
{


  programs.mpv = {
    enable = true;
    config = {
      ## Video
      profile=high-quality
      vo=gpu-next
      scale-antiring=0.6

      # Dither
      # This must be set to match your monitor's bit depth
      dither-depth = 8

      ## Behavior (personal preference)
      keep-open=yes
      save-position-on-quit

      ## Screenshots
      screenshot-format=png
      screenshot-dir="~/Pictures/mpv"
      screenshot-template="%F-%p-%n"
      screenshot-high-bit-depth=no

      ## Language Priority
      ## Sub
      ## Add enm before eng for honorifics
      slang=eng,en
      alang=jpn,ja

      ## Dub
      #slang=zxx,eng,en
      #alang=eng,en
      #subs-with-matching-audio=forced

      #skin
      osc = no
      border = no # Optional, but recommended

      # Volume
      volume-max=300
      volume=50

      # Loop video by default
      loop-file='inf'

    };
    bindings = {
      #g cycle-values glsl-shaders "~~/shaders/ArtCNN_C4F32.glsl" ""
      UP add volume 5
      DOWN add volume -5
      r cycle_values video-rotate 90 180 270 0
    };
  };

}
