-- FUNCTIONS FOR FILETYPE DETECTION
-- -----------------------------------
-- This function attempts to set the correct filetype for Docker Compose YAML files
function docker_compose_fix()
    -- Get the current file's name without extension
    local filename = vim.fn.expand("%:t:r")

    -- List of common Docker Compose file name patterns
    local docker_file_names = { "^docker%-compose", "^compose" }

    -- Iterate through the list of Docker Compose file name patterns
    for _, pattern in ipairs(docker_file_names) do
        -- Check if the current file's name matches any of the patterns
        if filename:match(pattern) then
            -- If it does, set the filetype to "yaml.docker-compose"
            vim.bo.filetype = "yaml.docker-compose"
            return
        end
    end
    -- If no Docker Compose file name pattern is matched, the function exits without changing the filetype
end

function DockerfileFix()
    -- Get the current file's name
    local filename = vim.fn.expand("%:t")

    -- Check if the filename starts with "Dockerfile"
    if filename:match("^Dockerfile") then
        -- Set the filetype to "dockerfile"
        vim.bo.filetype = "dockerfile"
    end
end

-- This function attempts to set the correct filetype for Ansible YAML files
function ansible_fix()
    -- Get the current file's full path
    local filepath = vim.fn.expand("%:p")

    -- List of directories commonly used in Ansible projects
    local ansible_dirs = { "/playbook/", "/tasks/", "/roles/" }

    -- Iterate through the list of Ansible directories
    for _, dir in ipairs(ansible_dirs) do
        -- Check if the current file's path contains any of the Ansible directories
        if filepath:match(dir) then
            -- If it does, set the filetype to "yaml.ansible"
            vim.bo.filetype = "yaml.ansible"
            return
        end
    end
    -- If no Ansible directory is found, the function exits without changing the filetype
end

function yaml_filetype_detector()
    -- Get the file extension
    local file_ext = vim.fn.expand("%:e")

    -- Only proceed if the file is a YAML file
    if file_ext ~= "yaml" and file_ext ~= "yml" then
        return
    end

    docker_compose_fix()
    ansible_fix()
end

-- Create an autocommand to run the yaml_filetype_detector function every time a file is read
vim.cmd([[au BufRead * lua yaml_filetype_detector()]])
vim.cmd([[au BufRead * lua DockerfileFix()]])
