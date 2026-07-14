{
  flake.modules.homeManager.graphicalGnome = {...}: {
    dconf.settings = {
      "org/gnome/desktop/app-folders" = {
        folder-children = [
          "accessories"
          "chromeapps"
          "games"
          "graphics"
          "internet"
          "office"
          "programming"
          "science"
          "soundvideo"
          "systemtools"
          "universalaccess"
          "wine"
        ];
      };

      "org/gnome/desktop/app-folders/folders/accessories" = {
        name = "Accessories";
        categories = ["Utility"];
      };
      "org/gnome/desktop/app-folders/folders/chromeapps" = {
        name = "Chrome Apps";
        categories = ["chrome-apps"];
      };
      "org/gnome/desktop/app-folders/folders/games" = {
        name = "Games";
        categories = ["Game"];
      };
      "org/gnome/desktop/app-folders/folders/graphics" = {
        name = "Graphics";
        categories = ["Graphics"];
      };
      "org/gnome/desktop/app-folders/folders/internet" = {
        name = "Internet";
        categories = ["Network" "WebBrowser" "Email"];
      };
      "org/gnome/desktop/app-folders/folders/office" = {
        name = "Office";
        categories = ["Office"];
      };
      "org/gnome/desktop/app-folders/folders/programming" = {
        name = "Programming";
        categories = ["Development"];
      };
      "org/gnome/desktop/app-folders/folders/science" = {
        name = "Science";
        categories = ["Science"];
      };
      "org/gnome/desktop/app-folders/folders/soundvideo" = {
        name = "Sound & Video";
        categories = ["AudioVideo" "Audio" "Video"];
      };
      "org/gnome/desktop/app-folders/folders/systemtools" = {
        name = "System Tools";
        categories = ["System" "Settings"];
      };
      "org/gnome/desktop/app-folders/folders/universalaccess" = {
        name = "Universal Access";
        categories = ["Accessibility"];
      };
      "org/gnome/desktop/app-folders/folders/wine" = {
        name = "Wine";
        categories = ["Wine" "X-Wine" "Wine-Programs-Accessories"];
      };
    };
  };
}
