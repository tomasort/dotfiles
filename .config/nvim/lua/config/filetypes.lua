local function docker_compose_fix()
  local filename = vim.fn.expand("%:t:r")
  local docker_file_names = { "^docker%-compose", "^compose" }

  for _, pattern in ipairs(docker_file_names) do
    if filename:match(pattern) then
      vim.bo.filetype = "yaml.docker-compose"
      return
    end
  end
end

local function dockerfile_fix()
  local filename = vim.fn.expand("%:t")

  if filename:match("^Dockerfile") then
    vim.bo.filetype = "dockerfile"
  end
end

local function ansible_fix()
  local filepath = vim.fn.expand("%:p")
  local ansible_dirs = { "/playbook/", "/tasks/", "/roles/" }

  for _, dir in ipairs(ansible_dirs) do
    if filepath:match(dir) then
      vim.bo.filetype = "yaml.ansible"
      return
    end
  end
end

local function yaml_filetype_detector()
  local file_ext = vim.fn.expand("%:e")

  if file_ext ~= "yaml" and file_ext ~= "yml" then
    return
  end

  docker_compose_fix()
  ansible_fix()
end

vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*",
  callback = function()
    yaml_filetype_detector()
    dockerfile_fix()
  end,
})