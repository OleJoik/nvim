local vim = vim

vim.api.nvim_create_user_command(
    'DiffviewFile',
    function()
        local current_file = vim.fn.expand("%")
        vim.cmd("DiffviewOpen -- " .. current_file)
        vim.cmd("DiffviewToggleFiles")
    end,
    {}
)

local function showCurrentGitInfo()
    -- Using vim.fn.system to execute shell commands and fetch the current commit hash
    local commit_hash = vim.fn.system('git rev-parse HEAD')

    -- Trimming any extra whitespace or newline from the output
    commit_hash = vim.fn.trim(commit_hash)

    -- Getting the current file path in the buffer
    local current_file = vim.fn.expand('%')

    -- Printing the information
    print("Current Commit: " .. commit_hash .. ", Active File: " .. current_file)
end


local function openFileAtCommit()
    -- Get the current file's relative path
    local current_file = vim.fn.expand('%')
    -- Fetch the current commit hash
    local commit_hash = vim.fn.system('git rev-parse HEAD')
    commit_hash = vim.fn.trim(commit_hash)

    -- Construct the git show command to get the file content at that commit
    local git_command = "git show " .. commit_hash .. ":" .. current_file

    -- Open a new vertical split to the left
    vim.cmd('leftabove vnew')
    -- Set the new buffer to read-only and non-modifiable
    -- vim.bo.readonly = true
    -- vim.bo.modifiable = false
    -- Use the git show output as the content of the new buffer
    vim.cmd('r! ' .. git_command)
    -- Delete the first empty line inserted by the read command
    vim.api.nvim_buf_set_lines(0, 0, 1, false, {})
    -- Set the buffer's name to reflect the commit it represents
    vim.api.nvim_buf_set_name(0, string.format('%s:%s', commit_hash, current_file))
end

vim.api.nvim_create_user_command(
    'GitFileInfo',  -- The name of the command
    openFileAtCommit,  -- The function to execute
    {desc = 'Display current Git commit and active file'}  -- Description for documentation
)

return {
  "sindrets/diffview.nvim",
  config = function()
    require("diffview").setup({
      view = {
        default = {
          layout = "diff1_plain"
        },
        file_history = {
          layout = "diff1_plain",
          winbar_info = false,
        },
      },
      file_panel = {
        listing_style = "list",             -- One of 'list' or 'tree'
        -- tree_options = {                    -- Only applies when listing_style is 'tree'
        --   flatten_dirs = true,              -- Flatten dirs that only contain one single dir
        --   folder_statuses = "only_folded",  -- One of 'never', 'only_folded' or 'always'.
        -- },
        win_config = {                      -- See |diffview-config-win_config|
          position = "left",
          width = 35,
          win_opts = {},
        },
      },
    })
  end,
}
