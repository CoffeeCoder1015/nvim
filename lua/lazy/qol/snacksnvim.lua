-- lazy.nvim
return {
	"folke/snacks.nvim",
	vscode = true,
	---@type snacks.Config
	---#232423
	opts = {
		scroll = { enabled = false },
		dashboard = {
			preset = {
				header = [[
					__|__ |___| |\                                   
					|o__| |___| | \                                  
					|___| |___| |o \                                 
				   _|___| |___| |__o\                                
				  /...\_____|___|____\_/                             
				  \   o * o * * o o  /                               
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
███████╗ █████╗ ██╗██╗          █████╗  ██████╗  █████╗ ██╗███╗   ██║
██╔════╝██╔══██╗██║██║         ██╔══██╗██╔════╝ ██╔══██╗██║████╗  ██║
███████╗███████║██║██║         ███████║██║  ███╗███████║██║██╔██╗ ██║
╚════██║██╔══██║██║██║         ██╔══██║██║   ██║██╔══██║██║██║╚██╗██║
███████║██║  ██║██║███████╗    ██║  ██║╚██████╔╝██║  ██║██║██║ ╚████║
╚══════╝╚═╝  ╚═╝╚═╝╚══════╝    ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝
]],
			},
			formats = {
				key = function(item)
					return { { "[", hl = "special" }, { item.key, hl = "key" }, { "]", hl = "special" } }
				end,
			},
			sections = {
				{ section = "header" },
				{ icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = { 2, 0 } },
				{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 2 },
				{ section = "keys", gap = 1, padding = { 2, 0 } },
				{ section = "startup" },
			},
		},
	},
}

-- 			header = [[
-- 	██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z
-- 	██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z
-- 	██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z
-- 	██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z
-- 	███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║
-- 	╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝
-- ]],
