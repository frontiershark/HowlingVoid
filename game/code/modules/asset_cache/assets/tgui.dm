// If you use a file(...) object, instead of caching the asset it will be loaded from disk every time it's requested.
// This is useful for development, but not recommended for production.
// And if TGS is defined, we're being run in a production environment.

#ifdef TGS
/datum/asset/simple/tgui
	keep_local_name = FALSE
	assets = list(
		"tgui.bundle.js" = "../interface/compiled/overlay/overlay.bundle.js",
		"tgui.bundle.css" = "../interface/compiled/overlay/overlay.bundle.css",
	)

/datum/asset/simple/tgui_panel
	keep_local_name = FALSE
	assets = list(
		"tgui-panel.bundle.js" = "../interface/compiled/chat-panel/chat-panel.bundle.js",
		"tgui-panel.bundle.css" = "../interface/compiled/chat-panel/chat-panel.bundle.css",
	)

#else
/datum/asset/simple/tgui
	keep_local_name = TRUE
	assets = list(
		"tgui.bundle.js" = file("../interface/compiled/overlay/overlay.bundle.js"),
		"tgui.bundle.css" = file("../interface/compiled/overlay/overlay.bundle.css"),
	)

/datum/asset/simple/tgui_panel
	keep_local_name = TRUE
	assets = list(
		"tgui-panel.bundle.js" = file("../interface/compiled/chat-panel/chat-panel.bundle.js"),
		"tgui-panel.bundle.css" = file("../interface/compiled/chat-panel/chat-panel.bundle.css"),
	)

#endif
