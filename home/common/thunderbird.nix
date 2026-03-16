{ ... }:

{
  programs.thunderbird = {
    enable = true;

    settings = {
      "mail.shell.checkDefaultClient" = false;
    };

    profiles.chris = {
      isDefault = true;
      settings = {
        "mailnews.start_page.enabled" = false;
        "mailnews.start_page.url" = "";
      };
    };
  };
}
