return {
	entry = function()
		local pwd_output, _ = Command("pwd"):stdout(Command.PIPED):output()
		local cwd = pwd_output.stdout:gsub("\n$", "")
		local fd_output, _ = Command("fd"):arg({ "--type", "d" }):stdout(Command.PIPED):output()
		if not fd_output or fd_output.stdout == "" then
			ya.notify({ title = "fd-fzf.yazi", content = "No directories found", level = "warn", timeout = 3 })
			return
		end

		local fd_list = fd_output.stdout:gsub("/\n", "\n"):gsub("/$", "")

		local permit = ui.hide()
		local child, spawn_err =
			Command("fzf"):stdin(Command.PIPED):stdout(Command.PIPED):stderr(Command.INHERIT):spawn()

		if not child then
			permit:drop()
			ya.notify({
				title = "fd-fzf.yazi",
				content = "fzf failed: " .. tostring(spawn_err),
				level = "error",
				timeout = 3,
			})
			return
		end

		child:write_all(fd_list)
		child:flush()
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
			ya.emit("cd", { cwd .. "/" .. selected, raw = true })
		end
	end,
}
