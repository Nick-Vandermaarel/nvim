--[[
C# Secrets Opener for Neovim

This Neovim plugin provides functionality to easily open the secrets.json file
associated with C# projects in a solution. It works by:

1. Finding the .sln file in the current directory
2. Parsing the .sln file to identify all .csproj files
3. Searching each .csproj file for a UserSecretsId
4. Locating the corresponding secrets.json file, either in the default user secrets
   location or in the project directory
5. Opening the first found secrets.json file in Neovim

Usage:
- Run the command :OpenCSharpSecrets

The plugin supports both Windows and Unix-like systems, adjusting the search
paths accordingly.

Note: This plugin requires Neovim and is designed for C# projects using the
standard .NET Core/5+ project structure with user secrets.

--]]
local M = {}

function M.find_sln_file()
    local current_dir = vim.fn.getcwd()
    return vim.fn.globpath(current_dir, '*.sln', false, 1)[1]
end

function M.get_csproj_files_from_sln(sln_file)
    local csproj_files = {}
    for line in io.lines(sln_file) do
        local project_name, project_path = line:match(
            'Project%("{[%w-]+}"%)[%s=]+"[^"]+"%,[%s]+"([^"]+)",%s+"({[%w-]+})"')
        if project_name and project_path then
            local full_path = vim.fn.fnamemodify(sln_file, ':h') .. '/' .. project_name
            if full_path:match('%.csproj$') then
                table.insert(csproj_files, full_path)
            end
        end
    end
    return csproj_files
end

function M.get_user_secrets_id(csproj_file)
    for line in io.lines(csproj_file) do
        local user_secrets_id = line:match('<UserSecretsId>(.-)</UserSecretsId>')
        if user_secrets_id then
            return user_secrets_id
        end
    end
    return nil
end

function M.find_secrets_file()
    local sln_file = M.find_sln_file()

    if sln_file then
        local csproj_files = M.get_csproj_files_from_sln(sln_file)

        for _, csproj_file in ipairs(csproj_files) do
            local user_secrets_id = M.get_user_secrets_id(csproj_file)
            if user_secrets_id then
                local secrets_file
                if vim.fn.has('win32') == 1 then
                    secrets_file = vim.fn.expand('$APPDATA') ..
                        '/Microsoft/UserSecrets/' .. user_secrets_id .. '/secrets.json'
                else
                    secrets_file = vim.fn.expand('~') .. '/.microsoft/usersecrets/' .. user_secrets_id .. '/secrets.json'
                end
                if vim.fn.filereadable(secrets_file) == 1 then
                    return secrets_file
                end
            end

            -- Also check for secrets.json in the project directory
            local project_secrets_file = vim.fn.fnamemodify(csproj_file, ':h') .. '/secrets.json'
            if vim.fn.filereadable(project_secrets_file) == 1 then
                return project_secrets_file
            end
        end

        print("secrets.json not found in any project directory or user secrets location.")
        return nil
    else
        print("No .sln file found in the current directory.")
        return nil
    end
end

function M.open_secrets_file()
    local secrets_file = M.find_secrets_file()

    if secrets_file then
        vim.cmd('edit ' .. secrets_file)
    end
end

-- Command to open secrets file
vim.api.nvim_create_user_command('OpenCSharpSecrets', M.open_secrets_file, {})

return M
