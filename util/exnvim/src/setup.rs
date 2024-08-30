use ::std::io::Write;

use ::cursive::CursiveExt;

#[derive(Clone, Copy)]
enum UseTransparentBg {
    Never,
    InDarkMode,
    InLightMode,
    Always,
}
impl ToString for UseTransparentBg {
    fn to_string(&self) -> String {
        String::from(match self {
            UseTransparentBg::Never => "never",
            UseTransparentBg::InDarkMode => "dark",
            UseTransparentBg::InLightMode => "light",
            UseTransparentBg::Always => "always",
        })
    }
}

#[derive(Clone, Copy)]
enum Background {
    Light,
    Dark,
}
impl ToString for Background {
    fn to_string(&self) -> String {
        String::from(match self {
            Background::Dark => "dark",
            Background::Light => "light",
        })
    }
}

#[derive(Clone, Copy)]
enum Language {
    Automatic,
    Russian,
    English,
}
impl ToString for Language {
    fn to_string(&self) -> String {
        String::from(match self {
            Language::Automatic => "auto",
            Language::Russian => "russian",
            Language::English => "english",
        })
    }
}

#[derive(Clone, Copy)]
enum FalseTrue {
    False,
    True,
}
impl ToString for FalseTrue {
    fn to_string(&self) -> String {
        String::from(match self {
            FalseTrue::False => "false",
            FalseTrue::True => "true",
        })
    }
}

#[derive(Clone, Copy, Debug)]
struct DotfilesSetupVimGetOptionsCursiveUserData {
    do_not_save: bool,
}
impl DotfilesSetupVimGetOptionsCursiveUserData {
    pub fn new() -> Self {
        DotfilesSetupVimGetOptionsCursiveUserData { do_not_save: false }
    }
}

#[derive(Clone)]
struct DotfilesVimConfigOptions {
    use_transparent_bg: UseTransparentBg,
    background: Background,
    cursorcolumn: FalseTrue,
    cursorline: FalseTrue,
    linenr: FalseTrue,
    language: Language,
}
impl DotfilesVimConfigOptions {
    pub fn new() -> Self {
        return DotfilesVimConfigOptions {
            use_transparent_bg: UseTransparentBg::InDarkMode,
            background: Background::Dark,
            cursorcolumn: FalseTrue::False,
            cursorline: FalseTrue::True,
            linenr: FalseTrue::True,
            language: Language::Automatic,
        };
    }
}

fn setup_get_options() -> ::std::io::Result<DotfilesVimConfigOptions> {
    let cursive_user_data = DotfilesSetupVimGetOptionsCursiveUserData::new();

    let mut app = ::cursive::Cursive::default();
    let mut use_transparent_bg_group: cursive::views::RadioGroup<UseTransparentBg> =
        cursive::views::RadioGroup::new();
    let mut background_group: cursive::views::RadioGroup<Background> =
        cursive::views::RadioGroup::new();
    let mut cursorcolumn_group: cursive::views::RadioGroup<FalseTrue> =
        cursive::views::RadioGroup::new();
    let mut cursorline_group: cursive::views::RadioGroup<FalseTrue> =
        cursive::views::RadioGroup::new();
    let mut linenr_group: cursive::views::RadioGroup<FalseTrue> = cursive::views::RadioGroup::new();
    let mut language_group: cursive::views::RadioGroup<Language> =
        cursive::views::RadioGroup::new();
    let label_effect = ::cursive::theme::Effect::Bold;
    let main_layer_view = ::cursive::views::Dialog::new()
        .content(
            ::cursive::views::ListView::new()
                .child(
                    "",
                    ::cursive::views::TextView::new("Use transparent background")
                        .effect(label_effect),
                )
                .child(
                    "",
                    ::cursive::views::LinearLayout::horizontal()
                        .child(use_transparent_bg_group.button(UseTransparentBg::Never, "never"))
                        .child(::cursive::views::DummyView)
                        .child(
                            use_transparent_bg_group
                                .button(UseTransparentBg::InDarkMode, "in dark mode")
                                .selected(),
                        )
                        .child(::cursive::views::DummyView)
                        .child(
                            use_transparent_bg_group
                                .button(UseTransparentBg::InLightMode, "in light mode"),
                        )
                        .child(::cursive::views::DummyView)
                        .child(use_transparent_bg_group.button(UseTransparentBg::Always, "always")),
                )
                .child(
                    "",
                    ::cursive::views::TextView::new("Background").effect(label_effect),
                )
                .child(
                    "",
                    ::cursive::views::LinearLayout::horizontal()
                        .child(background_group.button(Background::Dark, "dark").selected())
                        .child(::cursive::views::DummyView)
                        .child(background_group.button(Background::Light, "light")),
                )
                .child(
                    "",
                    ::cursive::views::TextView::new("Show cursor column").effect(label_effect),
                )
                .child(
                    "",
                    ::cursive::views::LinearLayout::horizontal()
                        .child(
                            cursorcolumn_group
                                .button(FalseTrue::False, "false")
                                .selected(),
                        )
                        .child(::cursive::views::DummyView)
                        .child(cursorcolumn_group.button(FalseTrue::True, "true")),
                )
                .child(
                    "",
                    ::cursive::views::TextView::new("Show cursor line").effect(label_effect),
                )
                .child(
                    "",
                    ::cursive::views::LinearLayout::horizontal()
                        .child(cursorline_group.button(FalseTrue::False, "false"))
                        .child(::cursive::views::DummyView)
                        .child(cursorline_group.button(FalseTrue::True, "true").selected()),
                )
                .child(
                    "",
                    ::cursive::views::TextView::new("Show line numbers").effect(label_effect),
                )
                .child(
                    "",
                    ::cursive::views::LinearLayout::horizontal()
                        .child(linenr_group.button(FalseTrue::False, "false"))
                        .child(::cursive::views::DummyView)
                        .child(linenr_group.button(FalseTrue::True, "true").selected()),
                )
                .child(
                    "",
                    ::cursive::views::TextView::new("Language").effect(label_effect),
                )
                .child(
                    "",
                    ::cursive::views::LinearLayout::horizontal()
                        .child(
                            language_group
                                .button(Language::Automatic, "Automatic")
                                .selected(),
                        )
                        .child(::cursive::views::DummyView)
                        .child(language_group.button(Language::Russian, "Russian"))
                        .child(::cursive::views::DummyView)
                        .child(language_group.button(Language::English, "English")),
                ),
        )
        .button("Save", move |s| {
            let mut user_data = cursive_user_data.clone();
            user_data.do_not_save = false;
            s.set_user_data(user_data);

            s.quit()
        })
        .button("Cancel", move |s| {
            let mut user_data = cursive_user_data.clone();
            user_data.do_not_save = true;
            s.set_user_data(user_data);

            s.quit()
        })
        .title("Setting up extra.nvim config");
    app.add_layer(main_layer_view);
    app.run();
    let user_data = app
        .user_data::<DotfilesSetupVimGetOptionsCursiveUserData>()
        .expect("Cannot get user data")
        .clone();
    let options = if !user_data.do_not_save {
        DotfilesVimConfigOptions {
            use_transparent_bg: *use_transparent_bg_group.selection(),
            background: *background_group.selection(),
            cursorcolumn: *cursorcolumn_group.selection(),
            cursorline: *cursorline_group.selection(),
            linenr: *linenr_group.selection(),
            language: *language_group.selection(),
        }
    } else {
        DotfilesVimConfigOptions::new()
    };
    Ok(options)
}

pub fn setup(home: ::std::path::PathBuf) -> ::std::io::Result<()> {
    let options = setup_get_options()?;
    let path = home.join(".config/exnvim/config.json");
    if !path.exists() {
        _ = ::std::fs::create_dir_all(path.parent().expect("Cannot get parent of a path"));
    }
    let mut f = ::std::fs::File::create(path).expect("Cannot open file for writing");
    f.write(
        ::encoding_rs::UTF_8
            .encode(
                &("{
\"_comment_AUTOGENERATED\":\"Autogenerated by `exnvim setup`\",
\"_comment_01\":\"Transparent background\",
\"_comment_02\":\"Values:\",
\"_comment_03\":\"    always - In dark and light theme\",
\"_comment_04\":\"    dark   - In dark theme\",
\"_comment_05\":\"    light  - In light theme\",
\"_comment_06\":\"    never  - Non-transparent\",
	\"use_transparent_bg\": \""
                    .to_owned()
                    + &options.use_transparent_bg.to_string()
                    + "\",

\"_comment_07\":\"Prevent setting up LSP if false\",
\"_comment_08\":\"Useful if it does not work\",
	\"setup_lsp\": false,

\"_comment_09\":\"light - light background\",
\"_comment_10\":\"dark - dark background\",
	\"background\": \"" + &options.background.to_string()
                    + "\",

\"_comment_11\":\"Use italic style for text\",
\"_comment_12\":\"Useful to disable for terminals with bugged italic font (like Termux)\",
	\"use_italic_style\": false,

\"_comment_13\":\"Enable or disable highlighting for current column\",
	\"cursorcolumn\": " + &options.cursorcolumn.to_string()
                    + ",

\"_comment_14\":\"Enable or disable highlighting for current line\",
	\"cursorline\": " + &options.cursorline.to_string()
                    + ",

\"_comment_15\":\"Enable or disable showing line numbers\",
	\"linenr\": " + &options.linenr.to_string()
                    + ",

\"_comment_16\":\"Change the style of line numbers\",
\"_comment_17\":\"Aviable: absolute, relative\",
	\"linenr_style\": \"relative\",

\"_comment_18\":\"Change style of cursorline\",
\"_comment_19\":\"    dim       - Small fogging (default)\",
\"_comment_20\":\"    reverse   - Swap fg with bg\",
\"_comment_21\":\"    underline - Underline a line\",
	\"cursorline_style\": \"dim\",

\"_comment_22\":\"Open quickui menu on start\",
	\"open_menu_on_start\": false,

\"_comment_23\":\"Change quickui_border_style\",
\"_comment_24\":\"1 - Dashed, non-Unicode\",
\"_comment_25\":\"2 - Solid\",
\"_comment_26\":\"3 - Double outer border (default)\",
	\"quickui_border_style\": \"3\",

\"_comment_27\":\"Change quickui colorscheme\",
\"_comment_28\":\"Aviable: borland, gruvbox, solarized, papercol dark, papercol light\",
\"_comment_29\":\"See them at https://github.com/skywind3000/vim-quickui/blob/master/MANUAL.md\",
	\"quickui_color_scheme\": \"papercol dark\",

\"_comment_30\":\"Open on start: alpha (default), ranger, explorer\",
	\"open_on_start\": \"alpha\",

\"_comment_31\":\"Enable Github Copilot\",
\"_comment_32\":\"Useful to disable if you do not have a subscription to it\",
	\"use_github_copilot\": false,

\"_comment_33\":\"Confirm dialogue width (vim-quickui)\",
\"_comment_34\":\"Default: 30\",
	\"pad_amount_confirm_dialogue\": 30,

\"_comment_35\":\"Change cursor style\",
\"_comment_36\":\"Aviable styles:\",
\"_comment_37\":\"  block (default)   █\",
\"_comment_38\":\"  bar               ⎸\",
\"_comment_39\":\"  underline         _\",
	\"cursor_style\": \"block\",

\"_comment_40\":\"Show or do not show tabline\",
\"_comment_41\":\"  0     Do not show\",
\"_comment_42\":\"  1     Show if there is only one tab\",
\"_comment_43\":\"  2     Show always (default)\",
	\"showtabline\": 2,

\"_comment_44\":\"Path style of tab in tabline\",
\"_comment_45\":\"  name      Show only filename (default)\",
\"_comment_46\":\"  short     Short path (relative to cwd and $HOME)\",
\"_comment_47\":\"  shortdir  Short path, reduce dirnames to 1 symbol\",
\"_comment_48\":\"  full      Show full filepath\",
	\"tabline_path\": \"name\",

\"_comment_49\":\"Spacing between tabs in tabline\",
\"_comment_50\":\"  none         abCd\",
\"_comment_51\":\"  full          a  b █C█ d \",
\"_comment_52\":\"  transition    a  b  C  d (default)\",
\"_comment_53\":\"  partial       a b█c█d \",
	\"tabline_spacing\": \"transition\",

\"_comment_54\":\"Show modified symbol ● on modified files\",
	\"tabline_modified\": true,

\"_comment_55\":\"Show icons before filename in tabline\",
\"_comment_56\":\"NOTE: You will need Nerd font\",
	\"tabline_icons\": true,

\"_comment_57\":\"Use mouse clicks for switching between tabs\",
	\"tabline_pressable\": true,

\"_comment_58\":\"Enable mouse clicks\",
	\"enable_mouse\": true,

\"_comment_59\":\"Automatically activate hovered windows\",
	\"mouse_focus\": false,

\"_comment_60\":\"Use nvim-cmp instead of coc.nvim\",
	\"use_nvim_cmp\": false,

\"_comment_61\":\"Show random text at start in alpha-nvim\",
	\"enable_fortune\": false,

\"_comment_62\":\"Show icons in quickui dialogues\",
	\"quickui_icons\": true,

\"_comment_63\":\"Interface language\",
\"_comment_64\":\"Aviable: auto (default), english, russian)\",
\"_comment_65\":\"This option does not change system locale and Vim interface language\",
	\"language\": \"" + &options.language.to_string()
                    + "\",

\"_comment_66\":\"Do things that require fast terminal\",
	\"fast_terminal\": false,

\"_comment_67\":\"Enable which-key.nvim plugin\",
	\"enable_which_key\": true,

\"_comment_68\":\"Compatibility mode\",
\"_comment_69\":\"Aviable: no (default), helix, helix_hard\",
	\"compatible\": \"no\",

\"_comment_70\":\"Enable nvim-treesitter-context plugin\",
\"_comment_71\":\"Useful to disable if it lags (for me it lags)\",
	\"enable_nvim_treesitter_context\": true,

	\"do_not_save_previous_column_position_when_going_up_or_down\": false,

    \"use_codeium\": false,

    \"open_cmd_on_up\": false,

    \"insert_exit_on_jk\": true,
    \"insert_exit_on_jk_save\": true,

\"_comment_end\":\"Ending field to not put comma every time\"
}"),
            )
            .0
            .to_mut(),
    )?;
    Ok(())
}
