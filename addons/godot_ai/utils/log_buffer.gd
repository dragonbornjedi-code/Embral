@tool
class_name McpLogBuffer
extends RefCounted

## Ring buffer for MCP log lines. Also prints to Godot console.

const MAX_LINES := 500

var _lines: Array[String] = []
## Monotonic count of every line ever passed to `log()` since the last
## `clear()`. Distinct from `_lines.size()`, which is bounded at MAX_LINES.
## Consumers that need to detect "new lines arrived" (e.g. `LogViewer.tick`)
## must track this rather than the bounded size — once the ring fills, the
## size stays at MAX_LINES on every subsequent append, so a size-based
## cursor would freeze and the consumer would stop seeing new entries.
var _total_logged: int = 0
var enabled := true
var _last_line := ""
var _last_line_repeat_count := 0


func log(msg: String) -> void:
	var line := "MCP | %s" % msg
	if line == _last_line:
		_last_line_repeat_count += 1
		return
	if _last_line_repeat_count > 0:
		_append_line("MCP | previous message repeated %d time(s)" % _last_line_repeat_count)
	_last_line = line
	_last_line_repeat_count = 0
	_append_line(line)


func _append_line(line: String) -> void:
	print(line)
	_lines.append(line)
	if _lines.size() > MAX_LINES:
		_lines = _lines.slice(-MAX_LINES)
	_total_logged += 1


func get_recent(count: int = 50) -> Array[String]:
	var start := maxi(0, _lines.size() - count)
	var result: Array[String] = []
	result.assign(_lines.slice(start))
	return result


func clear() -> void:
	_lines.clear()
	_last_line = ""
	_last_line_repeat_count = 0
	## Reset the monotonic counter so a viewer's `seq < _last_seq` shrink
	## detection still recognizes the clear. Callers that want a cumulative
	## ever-produced count across clears can wrap their own counter.
	_total_logged = 0


func total_count() -> int:
	return _lines.size()


## Monotonic sequence — number of lines ever appended via `log()` since
## the last `clear()`. Strictly increases per append, even once the ring
## has filled and `total_count()` is pinned at MAX_LINES. See `_total_logged`
## for rationale.
func total_logged() -> int:
	return _total_logged
