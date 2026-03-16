/datum/asset/simple/permissions
	assets = list(
		"search.js" = '../interface/native/panels/admin/search.js',
		"panels.css" = '../interface/native/panels/admin/panels.css'
	)

/datum/asset/group/permissions
	children = list(
		/datum/asset/simple/permissions,
		/datum/asset/simple/namespaced/common
	)
