return {
	entry = function()
		local cwd = tostring(cx.active.current.cwd)
		local fd_output, _ = Command("fd"):args({ "--type", "d" }):cwd(cwd):stdout(Command.PIPED):output()
		if not fd_output or fd_output.stdout == "" then
			ya.notify { title = "fd-fzf.yazi", content = "No directories found", level = "warn", timeout = 3 }
			return
		end

		local permit = ui.hide()
		local child, spawn_err = Command("fzf")
			:stdin(Command.PIPED)
			:stdout(Command.PIPED)
			:stderr(Command.INHERIT)
			:spawn()

		if not child then
			permit:drop()
			ya.notify { title = "fd-fzf.yazi", content = "fzf failed: " .. tostring(spawn_err), level = "error", timeout = 3 }
			return
		end

		child:write_all(fd_output.stdout)
		child:flush()
		local output, err = child:wait_with_output()
		permit:drop()

		if not output then
			ya.notify { title = "fd-fzf.yazi", content = tostring(err), level = "error", timeout = 3 }
			return
		end
		if not output.status.success then
			return
		end

		local selected = output.stdout:gsub("\n$", "")
		if selected ~= "" then
			ya.emit("cd", { cwd .. "/" .. selected, raw = true })
		end
	end,
}
