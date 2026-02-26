local M = {}

local state = ya.sync(function()
	return cx.active.current.cwd
end)

function M:entry()
	local cwd = state()

	local permit = ui.hide()
	local child, spawn_err = Command("sh")
		:arg("-c")
		:arg("fd --type d | fzf")
		:cwd(tostring(cwd))
		:stdout(Command.PIPED)
		:stderr(Command.INHERIT)
		:spawn()

	if not child then
		permit:drop()
		ya.notify({ title = "fd-fzf.yazi", content = "Failed: " .. tostring(spawn_err), level = "error", timeout = 3 })
		return
	end

	local output, err = child:wait_with_output()
	permit:drop()

	if not output then
		ya.notify({ title = "fd-fzf.yazi", content = tostring(err), level = "error", timeout = 3 })
		return
	end
	if not output.status.success then
		return
	end

	local selected = output.stdout:gsub("\n$", "")
	if selected ~= "" then
		ya.emit("cd", { cwd:join(selected), raw = true })
	end
end

return M
