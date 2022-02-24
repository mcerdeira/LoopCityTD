const PATH = 0
const DRAFT_PATH = 1

var binds = {
	PATH: [DRAFT_PATH],
	DRAFT_PATH: [PATH]
}

func _is_tile_bound(id, nid):
	return nid in binds[id]
