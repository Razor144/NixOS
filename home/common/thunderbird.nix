{ ... }:

{
  programs.thunderbird = {
    enable = true;

    settings = {
      "mail.shell.checkDefaultClient" = false;
    };

    profiles."d9j83j5a.default" = {
      isDefault = true;
      settings = {
        "mailnews.start_page.enabled" = false;
        "mailnews.start_page.url" = "";
      };
    };
  };
}
