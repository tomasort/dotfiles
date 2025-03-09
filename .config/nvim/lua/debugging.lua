local dap = require("dap")
local dapui = require("dapui")
dapui.setup()

vim.keymap.set("n", "<leader>dt", dap.toggle_breakpoint, { noremap = true })
vim.keymap.set("n", "<leader>dc", dap.continue, { noremap = true })

dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

-- DAP Python
-- require("dap-python").setup("uv")
require("dap-python").setup("python3")
